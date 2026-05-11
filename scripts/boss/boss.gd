extends CharacterBody2D
 
@onready var player = get_parent().find_child("character")
@onready var animated_sprite = $AnimatedSprite2D
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var hit_box_collision: CollisionShape2D = $HitBox/CollisionShape2D
@onready var hit_audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var boss_name: Label = $CanvasLayer/Name
var direction : Vector2

signal boss_died
 
var health: = 100:
	set(value):
		health = value
		progress_bar.value = value
		if value <= 0:
			boss_name.visible = false
			progress_bar.visible = false
			hit_box_collision.disabled = true
			boss_died.emit()
			find_child("FiniteStateMachine").change_state("Dead")
 
func _ready():
	set_physics_process(false)
 
 
func _process(_delta):
	direction = player.position - position
	if direction.x < 0:
		animated_sprite.flip_h = true
	else:
		animated_sprite.flip_h = false
 
func _physics_process(delta):
	velocity = direction.normalized() * 40
	move_and_collide(velocity * delta)
 
func take_damage(amount: int = 5):
	hit_audio.play()
	health -= amount
	print("enemy_health: ", health)
	animated_sprite.modulate = Color.WHITE * 5.0
	get_tree().create_timer(0.1).timeout.connect(func(): animated_sprite.modulate = Color.WHITE)
	shake()
	
func shake():
	var original_pos = position
	var shake_amount = 3.0
	var shake_speed = 0.05
	
	for i in range(6):
		position = original_pos + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		await get_tree().create_timer(shake_speed).timeout
	
	position = original_pos 
 
func _on_hit_box_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
