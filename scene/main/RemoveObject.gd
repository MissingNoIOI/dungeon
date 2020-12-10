extends Node2D


signal sprite_removed(remove_sprite, group_name, x, y)

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _ref_DungeonBoard: DungeonBoard

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

func remove(group_name: String, x: int, y: int) -> void:
	var sprite: Sprite = _ref_DungeonBoard.get_sprite(group_name, x, y)

	emit_signal("sprite_removed", sprite, group_name, x, y)
	sprite.queue_free()

func reparent_and_remove_parent(node,new_parent,group_name):
	var parent=node.get_parent()
	
	parent.remove_child(node) 	
	new_parent.add_child(node) 	
	print(node.position)
	node.position=parent.position
	print(node.position)
	node.show()
	
	var array=_new_ConvertCoord.vector_to_array(parent.position)
	remove(group_name,array[0],array[1]) 
