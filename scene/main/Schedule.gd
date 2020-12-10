extends Node2D


signal turn_started(current_sprite)
signal turn_ended(current_sprite)

var _new_GroupName := preload("res://library/GroupName.gd").new()

var _actors: Array = [null]
var _pointer: int = 0


func end_turn() -> void:
	#print("{0}: End turn.".format([_get_current().name]))
	emit_signal("turn_ended", _get_current())
	_goto_next()
	emit_signal("turn_started", _get_current())


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_actors[0] = new_sprite
	elif new_sprite.is_in_group(_new_GroupName.ZOMBIE):
		_actors.append(new_sprite)

func _on_RemoveObject_sprite_removed(remove_sprite: Sprite,
	_group_name: String, _x: int, _y: int) -> void:
		
	if remove_sprite.is_in_group(_new_GroupName.PC) or remove_sprite.is_in_group(_new_GroupName.ZOMBIE):	
		var current_sprite: Sprite = _get_current()
	
		_actors.erase(remove_sprite)
		_pointer = _actors.find(current_sprite)

func _get_current() -> Sprite:
	return _actors[_pointer] as Sprite


func _goto_next() -> void:
	_pointer += 1

	if _pointer > len(_actors) - 1:
		_pointer = 0

func clear_schedule()->void:
	var pc:=_actors[0] as Sprite
	_actors.clear()
	_actors=[null]
	_actors[0] = pc
	_pointer=0

func _on_InitWorld_level_changed()->void:
	clear_schedule()
