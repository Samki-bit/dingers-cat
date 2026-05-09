extends Node

func _ready():
	# Listen to GameState's signal — already fires when both levers pulled!
	GameState.all_levers_pulled.connect(_on_all_levers_pulled)
	print("LevelManager ready, listening for levers...")

func _on_all_levers_pulled():
	print("Both levers pulled! Transitioning...")
	await get_tree().create_timer(1.0).timeout
	GameState.reset()  # reset levers for next time
	get_tree().change_scene_to_file("res://scenes/levels/level3.tscn")
