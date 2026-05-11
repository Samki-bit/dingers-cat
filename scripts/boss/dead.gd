extends State
@onready var thanks: Label = $"../../CanvasLayer/Thanks"

func enter():
	super.enter()
	animation_player.play("death")

func boss_slained():
	animation_player.play("boss_killed")
