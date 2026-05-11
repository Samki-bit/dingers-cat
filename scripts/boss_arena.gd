extends Node2D

@onready var thanks: Label = $CanvasLayer/Thanks


func _ready() -> void:
	thanks.visible = false

func _on_boss_boss_died() -> void:
	await get_tree().create_timer(6.0).timeout
	thanks.visible = true
