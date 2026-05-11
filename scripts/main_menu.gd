extends Control
	
func _on_button_pressed() -> void:
	Transition.transition_to("res://scenes/levels/level1.tscn")


func _on_button_2_pressed() -> void:
	Transition.transition_to("res://scenes/levels/boss_arena.tscn")
