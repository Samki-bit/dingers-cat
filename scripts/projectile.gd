extends CharacterBody2D

signal take_damage

const SPEED = 100
var dir: Vector2
var spawn_position: Vector2
var spawn_rotation: float

func _ready():
	global_position = spawn_position
	global_rotation = spawn_rotation
	get_tree().create_timer(2.0).timeout.connect(queue_free) 

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision:
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(10)
		queue_free()
