extends Area2D

@onready var collison: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var next_level: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collison.disabled = true
	sprite.visible = false

func open(level):
		collison.disabled = false
		sprite.visible = true
		sprite.play("open")
		next_level = level

func _on_body_entered(body: Node2D) -> void:
	body.queue_free()
	sprite.play("close")
	await sprite.animation_finished
	print(sprite.animation_finished)
	Transition.transition_to_next_level(next_level)
