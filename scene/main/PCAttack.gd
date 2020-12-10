extends Node2D

signal pc_attacked(message)

const Troll := preload("res://sprite/spritescripts/TrollScript.gd")
const Blood := preload("res://sprite/Blood.tscn")

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const RemoveObject := preload("res://scene/main/RemoveObject.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const InitWorld := preload("res://scene/main/InitWorld.gd")

var _ref_DungeonBoard: DungeonBoard
var _ref_RemoveObject: RemoveObject
var _ref_Schedule: Schedule
var _ref_InitWorld: InitWorld

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_Combat := preload("res://library/Combat.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

func attack(_pc,group_name: String, x: int, y: int) -> void:
	if not _ref_DungeonBoard.has_sprite(group_name, x, y):
		return
	
	var enemy:Sprite=_ref_DungeonBoard.get_sprite(group_name,x,y)
	
	if enemy.weakness==_pc.special and _new_Combat.roll(1,6)>2:

		var _success=_new_Combat.special(_pc,enemy)
		if not _success:
			emit_signal("pc_attacked", "special failed")
		else:
			emit_signal("pc_attacked", "You launch special:"+_pc.special)
	else:
		var _success=_new_Combat.attack(_pc,enemy)
		if _success:
			emit_signal("pc_attacked", "Player hit:"+ enemy.get_name())
			$"../../Audio/AttackSound".play()
		else:
			emit_signal("pc_attacked", "Player launch a hit but it fails")
	if enemy.hp<=0:
		#if enemy is Troll:
		#	enemy.drop_item(_ref_InitWorld,x,y)
		var blood = Blood.instance()
		blood.position=_new_ConvertCoord.index_to_vector(x,y,0,0)
		var node=get_node("/root/MainScene/StaticMap")
		node.add_child(blood)
		blood.set_owner(node)
		
		_ref_RemoveObject.remove(group_name, x, y)
		emit_signal("pc_attacked", "[color=red]You kill:"+ enemy.get_name()+"[/color]")
		$"../../Audio/EnemyDeath".play()
		if enemy is Troll:
			emit_signal("pc_attacked", "[wave amp=50 freq=8][color=blue]Congrats: You Finished the game![/color][/wave]")
	_ref_Schedule.end_turn()

