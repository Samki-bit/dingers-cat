extends ProgressBar

var health  = 100 : set = _set_health

func _set_health(new_health):
	health = min(max_value, new_health)
	value = health

func init_health(_health):
	health = health
	value = health
	
