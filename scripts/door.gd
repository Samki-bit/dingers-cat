extends StaticBody2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var door_id: int

func _ready():
	GameState.door_opened.connect(_on_door_opened)

func _on_door_opened(id: int):
	if id == door_id:
		open()

func open():
	collision.set_deferred("disabled", true)
	animation.play("open")
