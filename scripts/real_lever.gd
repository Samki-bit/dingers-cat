extends Area2D

@export var lever_id: String = "alive"
@export var world: String = "alive"    

var pulled: bool = false

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label


func _ready():
	label.visible = false
func _process(_delta):
	if pulled:
		return
	for body in get_overlapping_bodies():
		if Input.is_action_just_pressed("interact"):
			pull()

func pull():
	pulled = true
	sprite.play("pulled")
	GameState.pull_lever(lever_id)


func _on_body_entered(body: Node2D) -> void:
	if not pulled:
		label.visible = true
		print("hehe")


func _on_body_exited(body: Node2D) -> void:
	label.visible = false
