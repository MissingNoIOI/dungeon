extends Sprite


const PC := preload("res://sprite/spritescripts/PCScript.gd")
const stone_texture:=preload("res://resource/stone.png")

var _new_StoneStats := preload("res://library/items/StoneStats.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC
	_pc.ar = _pc.initial_ar + _new_StoneStats.INCREASE_AR
	
	_pc.special=_new_StoneStats.SPECIAL_ATTACK
	
	var remove=null
	for w in _pc.get_children():
		print(w.name)
		if w.get_name()=="weapon":
			remove=w
			
	if remove!=null:
		_pc.remove_child(remove)
	
	var sprite = Sprite.new()
	sprite.set_texture(stone_texture)
	sprite.position=Vector2(-6,2)
	sprite.set_name("weapon")
	_pc.add_child(sprite)
	sprite.set_owner(_pc)

