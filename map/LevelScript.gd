extends Node2D

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

func get_next_level_position()->Array:
	return _new_ConvertCoord.vector_to_array(get_node("NextLevel").position)


func get_start_position()->Array:
	return _new_ConvertCoord.vector_to_array(get_node("Start").position)

func get_boss_position()->Array:
	return _new_ConvertCoord.vector_to_array(get_node("Boss").position)

func get_clear_area()->Polygon2D:
	if has_node("ClearArea"):
		return get_node("ClearArea") as Polygon2D
	else:
		return null
