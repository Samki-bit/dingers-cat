extends CharacterBody2D

@onready var projectile = preload("res://scenes/enemy/projectile.tscn")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var enemy_door: StaticBody2D = $"../../AliveWorld/EnemyDoor"

const MOVE_SPEED: int = 40
var target: Node2D = null
var health: int = 10
var is_chasing: bool = false

func _ready():
	shoot_timer.wait_time = 2.0
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(_delta: float) -> void:
	if target and is_instance_valid(target):
		if target.player_state == target.PlayerState.ALIVE:
			face_target(target.global_position)
			chase_target(target.global_position)
		else:
			velocity = Vector2.ZERO  # stop chasing in dead state
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func chase_target(target_position: Vector2):
	var dir = global_position.direction_to(target_position)
	velocity = dir * MOVE_SPEED

func shoot(target_position: Vector2):
	var bullet = projectile.instantiate()
	var dir = global_position.direction_to(target_position)
	bullet.dir = dir
	bullet.spawn_position = global_position
	bullet.spawn_rotation = dir.angle()
	get_parent().add_child(bullet)

func _on_shoot_timer_timeout():
	if target and is_instance_valid(target):
		if target.player_state == target.PlayerState.ALIVE:
			shoot(target.global_position)

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.player_state == body.PlayerState.ALIVE:
		target = body
		is_chasing = true
		shoot(body.global_position)
		shoot_timer.start()

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		is_chasing = false
		velocity = Vector2.ZERO
		shoot_timer.stop()

func face_target(target_position: Vector2):
	var dir = global_position.direction_to(target_position)
	if abs(dir.x) >= abs(dir.y):
		sprite.flip_h = dir.x < 0

func take_damage(amount: int = 1):
	health -= amount
	print("enemy_health: ", health)
	sprite.modulate = Color.RED
	get_tree().create_timer(0.1).timeout.connect(func(): sprite.modulate = Color.WHITE)
	shake()
	if health <= 0:
		die()

func die():
	if target and is_instance_valid(target):
		target.collect_kibble()
	open_door()
	queue_free()

func open_door():
	if enemy_door:
		if is_instance_valid(enemy_door):
			enemy_door.open()

func shake():
	var original_pos = position
	var shake_amount = 3.0
	var shake_speed = 0.05
	for i in range(6):
		position = original_pos + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		await get_tree().create_timer(shake_speed).timeout
	position = original_pos
