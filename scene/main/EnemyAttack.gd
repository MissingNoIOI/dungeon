extends Node2D

signal enemy_attacked(message)

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const PCMove := preload("res://scene/main/PCMove.gd")

var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule
var _ref_PCMove: PCMove

var _new_Combat := preload("res://library/Combat.gd").new()

func attack(enemy:Sprite,_pc:Sprite) -> void:	
	var success=_new_Combat.attack(enemy,_pc)
	_ref_Schedule.end_turn()
	if !_pc.die and _pc.hp<=0:
		_pc.die=true
		_ref_PCMove.die()
	if success:
		emit_signal("enemy_attacked", "[color=red]"+ enemy.attack_message+ "[/color]")
