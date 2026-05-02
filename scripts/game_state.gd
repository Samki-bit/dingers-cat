
extends Node

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

func reset():
	levers = {"alive": false, "dead": false}
