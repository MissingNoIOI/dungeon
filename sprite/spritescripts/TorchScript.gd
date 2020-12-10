extends Sprite


const PC := preload("res://sprite/spritescripts/PCScript.gd")
const torch_texture:=preload("res://resource/torch.png")

var _new_TorchStats := preload("res://library/items/TorchStats.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()

func collected_by(_pc:Sprite) -> void:
	_pc = _pc as PC
	_pc.ar = _pc.initial_ar + _new_TorchStats.INCREASE_AR
		
	_pc.special=_new_TorchStats.SPECIAL_ATTACK
	
	var remove=null
	for w in _pc.get_children():
		print(w.name)
		if w.get_name()=="weapon":
			remove=w
			
	if remove!=null:
		_pc.remove_child(remove)
		
	var sprite = Sprite.new()
	sprite.set_texture(torch_texture)
	sprite.position=Vector2(-6,2)
	sprite.set_name("weapon")
	_pc.add_child(sprite)
	sprite.set_owner(_pc)
	

