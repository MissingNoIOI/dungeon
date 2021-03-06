extends Sprite

class_name Door




var _new_GroupName := preload("res://library/GroupName.gd").new()


const PC := preload("res://sprite/spritescripts/PCScript.gd")

var opened:=false

const StaticMap ="/root/MainScene/StaticMap"

func opened_by(_pc:Sprite,_ref_RemoveObject:Node2D) -> bool:
	_pc = _pc as PC

	if not opened:
		opened=true		
		var static_map=get_node(StaticMap)
		
		_ref_RemoveObject.call_deferred("reparent_and_remove_parent",$OpenSprite,static_map,_new_GroupName.DOOR)
		print("door opened")	
		return true
	return false


