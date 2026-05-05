extends Node

signal door_opened(door_id: String)
signal lever_pulled(lever_id: String)
signal all_levers_pulled

var levers: Dictionary = {
	"alive": false,
	"dead": false,
}

func pull_lever(lever_id: String):
	levers[lever_id] = true
	lever_pulled.emit(lever_id)
	if levers.values().all(func(v): return v):
		all_levers_pulled.emit()

func trigger_door(door_id: int):
	door_opened.emit(door_id)

func reset():
	levers = {"alive": false, "dead": false}
