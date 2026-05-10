extends CharacterBody2D

@onready var projectile = preload("res://scenes/enemy/projectile.tscn")
@onready var kibble = preload("res://scenes/objects/kibble.tscn")
@onready var shoot_timer: Timer = $ShootTimer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurt_audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

var target: Node2D = null
var health: int = 10
func _ready():
	shoot_timer.wait_time = 2.0
	shoot_timer.one_shot = false
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)

func _physics_process(_delta: float) -> void:
	if target:
		if target.player_state == target.PlayerState.ALIVE:
			face_target(target.global_position)

func shoot(target_position: Vector2):
	var bullet = projectile.instantiate()
	var dir = global_position.direction_to(target_position)
	bullet.dir = dir
	bullet.spawn_position = global_position
	bullet.spawn_rotation = dir.angle()
	get_parent().add_child(bullet)
	sprite.play("throw")

func _on_shoot_timer_timeout():
	if target.player_state == target.PlayerState.ALIVE:
		shoot(target.global_position)

func _on_attack_zone_body_entered(body: Node2D) -> void:
	if body.player_state == body.PlayerState.ALIVE:
		target = body
		shoot(body.global_position)  
		shoot_timer.start()         

func _on_attack_zone_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		shoot_timer.stop()

func face_target(target_position: Vector2):
	var dir = global_position.direction_to(target_position)
	if abs(dir.x) >= abs(dir.y):
		sprite.flip_h = dir.x < 0

func take_damage(amount: int = 1):
	hurt_audio.play()
	health -= amount
	print("enemy_health: ", health)
	sprite.modulate = Color.WHITE * 5.0
	get_tree().create_timer(0.1).timeout.connect(func(): sprite.modulate = Color.WHITE)
	shake()
	if health <= 0:
		die()

func die():
	if target and is_instance_valid(target):
		target.collect_kibble()
	queue_free()
	
func shake():
	var original_pos = position
	var shake_amount = 3.0
	var shake_speed = 0.05
	
	for i in range(6):
		position = original_pos + Vector2(randf_range(-shake_amount, shake_amount), randf_range(-shake_amount, shake_amount))
		await get_tree().create_timer(shake_speed).timeout
	
	position = original_pos 
