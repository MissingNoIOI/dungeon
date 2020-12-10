extends Item

class_name GoldenArmor

const PC := preload("res://sprite/spritescripts/PCScript.gd")
const armored_texture:=preload("res://resource/golden_armored.png")

var _new_ArmorStats := preload("res://library/items/GoldenArmorStats.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC

	_pc.dr=_pc.initial_dr+_new_ArmorStats.INCREASE_DR	
	_pc.set_texture(armored_texture)	
