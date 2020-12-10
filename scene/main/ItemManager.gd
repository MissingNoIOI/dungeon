extends Node2D

const RemoveObject := preload("res://scene/main/RemoveObject.gd")
var _ref_RemoveObject: RemoveObject

func collect(_pc:Sprite,item:Sprite,_group:String ,_x:int,_y:int) -> void:
	item.collected_by(_pc) 
	_ref_RemoveObject.remove(_group,_x,_y)
