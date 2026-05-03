extends Area2D
signal kibble_collected

func _on_body_entered(_body: Node2D) -> void:
	emit_signal("kibble_collected")
	queue_free()
	
