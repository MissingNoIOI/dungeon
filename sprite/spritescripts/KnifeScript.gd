extends Sprite


const PC := preload("res://sprite/spritescripts/PCScript.gd")
const knife_texture:=preload("res://resource/knife.png")

var _new_KnifeStats := preload("res://library/items/KnifeStats.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC
	_pc.ar = _pc.initial_ar + _new_KnifeStats.INCREASE_AR
	
	_pc.special=_new_KnifeStats.SPECIAL_ATTACK
	
	var remove=null
	for w in _pc.get_children():
		print(w.name)
		if w.get_name()=="weapon":
			remove=w
			
	if remove!=null:
		_pc.remove_child(remove)
		
	var sprite = Sprite.new()
	sprite.set_texture(knife_texture)
	sprite.position=Vector2(-6,2)
	sprite.set_name("weapon")
	_pc.add_child(sprite)
	sprite.set_owner(_pc)
	

