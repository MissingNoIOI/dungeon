extends Item

class_name SilverArmor

const PC := preload("res://sprite/spritescripts/PCScript.gd")
const armored_texture:=preload("res://resource/silver_armored.png")

var _new_ArmorStats := preload("res://library/items/SilverArmorStats.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC

	_pc.dr=_pc.initial_dr+_new_ArmorStats.INCREASE_DR	
	_pc.set_texture(armored_texture)	
