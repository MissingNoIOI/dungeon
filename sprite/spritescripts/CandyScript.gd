extends Sprite


const PC := preload("res://sprite/spritescripts/PCScript.gd")

var _new_CandyStats := preload("res://library/items/CandyStats.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC
	_pc.hp += _new_CandyStats.RECOVERY_HP
	
	#set the maximum hp
	if _pc.hp>_new_PCStats.HP:
		_pc.hp=_new_PCStats.HP
