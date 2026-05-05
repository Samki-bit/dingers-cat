extends Node2D

@onready var alive_world: Node2D = $AliveWorld
@onready var dead_world: Node2D = $DeadWorld
@onready var player: CharacterBody2D = $Character
@onready var door: StaticBody2D = $DeadWorld/Door
@onready var pressure_plate: Area2D = $AliveWorld/PressurePlate
@onready var door_2: StaticBody2D = $AliveWorld/Door2
@onready var pressure_plate_2: Area2D = $DeadWorld/PressurePlate2

func _ready():
	GameState.reset()
	player.state_changed.connect(_on_player_state_changed)
	GameState.all_levers_pulled.connect(_on_all_levers_pulled)
	pressure_plate.pressure_plate_triggered.connect(_on_pressure_plate_triggered)
	pressure_plate_2.pressure_plate_triggered.connect(_on_pressure_plate_2_triggered)
	update_world_visibility()

func _on_player_state_changed():
	update_world_visibility()

func _on_all_levers_pulled():
	print("level_completed")

func _on_pressure_plate_triggered():
	door.open()
	
func _on_pressure_plate_2_triggered():
	door_2.open()

func update_world_visibility():
	var is_alive = player.player_state == player.PlayerState.ALIVE
	alive_world.visible = is_alive
	dead_world.visible = not is_alive
