extends ProgressBar

var mana  = 0 : set = _set_mana

func _set_mana(new_mana):
	mana = min(max_value, new_mana)
	value = mana

func init_mana(_mana):
	mana = _mana
	value = mana
	
