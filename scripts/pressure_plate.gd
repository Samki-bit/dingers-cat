extends Area2D

signal pressure_plate_triggered

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@export var pressure_plate_id: int 

var is_triggered: bool= false

func _on_body_entered(body: Node2D) -> void:
	if not is_triggered:
		is_triggered = true
		GameState.trigger_door(pressure_plate_id)
		animation.play("triggered")
	
