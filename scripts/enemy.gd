extends CharacterBody2D

@onready var projectile = preload("res://scenes/enemy/projectile.tscn")
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var shoot_timer: Timer = $ShootTimer

var target: Node2D = null

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
