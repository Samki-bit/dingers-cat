# level1.gd
extends Node2D

@onready var alive_world: Node2D = $AliveWorld
@onready var dead_world: Node2D = $DeadWorld
@onready var player: CharacterBody2D = $CharacterBody2D


func _ready():
	GameState.reset()
	player.state_changed.connect(_on_player_state_changed)
	GameState.all_levers_pulled.connect(_on_all_levers_pulled)
	update_world_visibility()

func _on_player_state_changed():
	update_world_visibility()

func _on_all_levers_pulled():
	print("level_completed")

func update_world_visibility():
	var is_alive = player.player_state == player.PlayerState.ALIVE
	alive_world.visible = is_alive
	dead_world.visible = not is_alive
