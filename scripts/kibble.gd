extends Area2D

func _on_body_entered(body: Node2D) -> void:
	body.collect_kibble()
	queue_free()
	
