extends Item

class_name Key

const PC := preload("res://sprite/spritescripts/PCScript.gd")

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC
	_pc.has_key=true
