extends CharacterBody2D
enum PlayerState {
	ALIVE,
	DEAD
}
#ALIVE 
const ALIVE_SPEED: int = 50
const DASH_SPEED: int = 200
#DEAD 
const DEAD_SPEED: int = 70
#PLAYING
var player_state = PlayerState.ALIVE
var speed: int = ALIVE_SPEED
var direction: Vector2
var mana: int = 100
var max_mana: int = 100
var health: int = 100
var is_dashing: bool = false
var is_walking: bool = false
var is_transitioning: bool = false  
var is_attacking: bool = false
var can_switch_mode := true

@onready var hit_box: Area2D = $HitBox
@onready var dash_timer: Timer = $DashTimer
@onready var mana_timer: Timer = $ManaTimer
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var mana_bar: ProgressBar = $CanvasLayer/ManaBar
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var hurt_audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var last_direction: String
signal state_changed

func _ready():
	print("PLAYER READY")
	print(get_groups())
	mana_timer.wait_time = 1.0
	mana_timer.autostart = true
	mana_timer.start()
	mana_bar.init_mana(mana)
	health_bar.init_health(health)
	animation.animation_finished.connect(_on_animation_finished)  

func _get_direction_suffic(dir: Vector2) -> String:
	if abs(dir.x) > abs(dir.y):
		return "left" if dir.x < 0 else "right"
	else:
		return "up" if dir.y < 0 else "down"

func _on_animation_finished():
	if not is_transitioning:
		return
	is_transitioning = false
	if player_state == PlayerState.ALIVE and mana > 0:
		player_state = PlayerState.DEAD
		enter_dead_state()
	else:
		player_state = PlayerState.ALIVE
		enter_real_state()

func _physics_process(_delta: float) -> void:
	handle_movement()
	handle_animation()
	handle_combat()
	move_and_slide()

func handle_movement():
	if is_transitioning:
		velocity = Vector2.ZERO
		return 

	if Input.is_action_just_pressed("dash") and not is_dashing:
		start_dash()
	if Input.is_action_just_pressed("switch") and can_switch_mode:
		if player_state == PlayerState.ALIVE and mana <= 0:
			print("not enough mana!")
		else:
			switch_state()
	
	direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if is_dashing:
		velocity = direction * DASH_SPEED if direction != Vector2(0,0) else velocity
		if player_state == PlayerState.DEAD: set_collision_mask_value(2, false)
	else:
		set_collision_mask_value(2, true)
		velocity = direction * speed

func handle_animation() -> void:
	if is_transitioning:
		return  
	if player_state == PlayerState.ALIVE:
		handle_state_animaiton("alive")
	else:
		handle_state_animaiton("dead")

func handle_combat():
	hit_box.monitoring = false
	var dir
	if Input.is_action_just_pressed("jump") and not is_attacking and not is_transitioning:
		is_attacking = true
		hit_box.monitoring = true
		#animation.flip_v = direction.y < 0
		#if player_state == PlayerState.ALIVE:
			#animation.play("alive_attack")
		#else:
			#animation.play("dead_attack")
		if direction != Vector2.ZERO:
			dir = _get_direction_suffic(direction)
			last_direction = dir
		else:
			dir = last_direction
		if player_state == PlayerState.ALIVE:
			animation.play("alive_attack_" + dir)
		else:
			animation.play("dead_attack_" + dir)
		get_tree().create_timer(0.1).timeout.connect(func():
			is_attacking = false
			hit_box.monitoring = false
		)

func handle_state_animaiton(state):
	if is_attacking:
		return
	var dir
	if direction != Vector2.ZERO:
		dir = _get_direction_suffic(direction)
		last_direction = dir
	else:
		dir = last_direction
	if is_dashing:
		animation.play(state + "_dash_" + dir)
	elif direction==Vector2.ZERO:
		animation.play(state + "_idle_" + dir)
	else:
		animation.play(state + "_walk_" + dir)
		
	#animation.flip_v = direction.y < 0
	#if direction.x != 0:
		#animation.flip_h = direction.x < 0
	#if direction.y != 0:
		#animation.flip_v = direction.y > 0
	#if is_dashing:
		#if direction == Vector2.LEFT or direction == Vector2.RIGHT:
			#animation.play(state + "_dash_sideways")
		#else:
			#animation.play(state + "_dash_updown")
	#elif direction == Vector2.ZERO:
		#animation.play(state + "_idle")
	#elif direction == Vector2.LEFT or direction == Vector2.RIGHT:
		#animation.play(state + "_walk_sideways")
	#else:
		#animation.play(state + "_walk_updown")

func switch_state():
	if is_transitioning:
		return
	is_transitioning = true
	if player_state == PlayerState.ALIVE:
		animation.play("transition_to_dead")
	else:
		animation.play("transition_to_alive")

func _on_mana_timer_timeout():
	if player_state == PlayerState.DEAD:
		mana -= 5
		mana = max(mana, 0)
		mana_bar._set_mana(mana)
		if mana <= 0:
			switch_state()

func take_damage(amount: int):
	hurt_audio.play()
	health -= amount
	health_bar._set_health(health)
	if health <= 0:
		die()

func die():
	queue_free()

func start_dash():
	is_dashing = true
	dash_timer.start()

func _on_dash_timer_timeout():
	is_dashing = false

func enter_dead_state():
	speed = DEAD_SPEED
	state_changed.emit()
	set_collision_layer_value(9, true)
	set_collision_layer_value(5, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(6, true)
	set_collision_mask_value(2, false)

func enter_real_state():
	speed = ALIVE_SPEED
	state_changed.emit()
	set_collision_layer_value(9, false)
	set_collision_layer_value(5, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(6, false)
	set_collision_mask_value(2, true)

func collect_kibble() -> void:
	if mana <= max_mana:
		mana += 10
		mana_bar._set_mana(mana)
		print("mana:", mana)
	else:
		print("max mana")

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
