extends StaticBody2D
@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func open():
	collision.set_deferred("disabled", true)  
	print(collision.disabled)
	animation.play("open")
