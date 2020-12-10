extends Node2D


const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const ItemManager := preload("res://scene/main/ItemManager.gd")
const InitWorld := preload("res://scene/main/InitWorld.gd")

var _ref_InitWorld: InitWorld
var _ref_DungeonBoard: DungeonBoard
var _ref_ItemManager: ItemManager
var _ref_Schedule: Schedule

const RemoveObject := preload("res://scene/main/RemoveObject.gd")
var _ref_RemoveObject: RemoveObject

const DungeonSize := preload("res://scene/main/DungeonSize.gd")
var _ref_DungeonSize : DungeonSize

const PauseMenu := preload("res://scene/gui/PauseMenu.gd")
var _ref_PauseMenu: PauseMenu

const PauseManager := preload("res://scene/main/PauseManager.gd")
var _ref_PauseManager: PauseManager

signal pc_moved(message)
signal pc_moved_board(message)


const PC_ATTACK: String = "PCAttack"

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_InputName := preload("res://library/InputName.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()
var _new_GroundName := preload("res://library/GroundName.gd").new()


var _pc: Sprite

var _rng := RandomNumberGenerator.new()

var _move_inputs: Array = [
	_new_InputName.MOVE_LEFT,
	_new_InputName.MOVE_RIGHT,
	_new_InputName.MOVE_UP,
	_new_InputName.MOVE_DOWN,
	_new_InputName.MOVE_UP_LEFT,
	_new_InputName.MOVE_UP_RIGHT,
	_new_InputName.MOVE_DOWN_LEFT,
	_new_InputName.MOVE_DOWN_RIGHT,
	_new_InputName.WAIT,
]


func _ready() -> void:
	set_process_unhandled_input(false)
	_rng.randomize()


func _unhandled_input(event: InputEvent) -> void:

	var source: Array = _new_ConvertCoord.vector_to_array(_pc.position)
	var target: Array

	if _is_wait_input(event):
		set_process_unhandled_input(false)
		_ref_Schedule.end_turn()
		emit_signal("pc_moved", "You wait one turn.")
		emit_signal("pc_moved_board",_pc, _new_GroupName.PC,source[0],source[1])#don't move but emit the signal like to do fov
	elif _is_move_input(event):
		target = _get_new_position(event, source)
		_try_move(target[0], target[1])



func _is_reload_input(event: InputEvent) -> bool:
	if event.is_action_pressed(_new_InputName.RELOAD):
		return true
	return false



func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		set_process_unhandled_input(true)

func _is_move_input(event: InputEvent) -> bool:
	for m in _move_inputs:
		if event.is_action_pressed(m):
			return true
	return false


func _is_wait_input(event: InputEvent) -> bool:
	if event.is_action_pressed(_new_InputName.WAIT):
		return true
	return false


func _try_move(x: int, y: int) -> void:
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):
		emit_signal("pc_moved", "You cannot leave the map.")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.DOOR, x, y):		
		var sprite = _ref_DungeonBoard.get_sprite(_new_GroupName.DOOR, x, y)
		if _pc.has_key and sprite.opened_by(_pc,_ref_RemoveObject):
			set_process_unhandled_input(false)
			emit_signal("pc_moved", "You open the door.")			
			_pc.has_key=false				
			_ref_Schedule.end_turn()
		else:
			emit_signal("pc_moved", "The door is closed.")
	elif _ref_DungeonBoard.is_wall(x, y):
		emit_signal("pc_moved", "You bump into wall.")
	elif _ref_DungeonBoard.is_transparent_wall(x, y):
		emit_signal("pc_moved", "You can't do it.")
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.ZOMBIE, x, y):
		set_process_unhandled_input(false)
		get_node(PC_ATTACK).attack(_pc,_new_GroupName.ZOMBIE, x, y)
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.CHEST, x, y):		
		var sprite = _ref_DungeonBoard.get_sprite(_new_GroupName.CHEST, x, y)
		if sprite.opened_by(_pc,_ref_RemoveObject):
			set_process_unhandled_input(false)
			emit_signal("pc_moved", "You've got a key.")			
			_pc.has_key=true
			_ref_Schedule.end_turn()
	else:
		set_process_unhandled_input(false)	
		
		#make move	
		var old_position=_new_ConvertCoord.vector_to_array(_pc.position)
		_pc.position = _new_ConvertCoord.index_to_vector(x, y)	
		emit_signal("pc_moved_board",_pc, _new_GroupName.PC,old_position[0],old_position[1])
		
		#collect items
		var item = _ref_DungeonBoard.get_sprite(_new_GroupName.ITEM, x, y)
		if item!=null:
			_ref_ItemManager.collect(_pc,item,_new_GroupName.ITEM,x,y)	
			#print("item collected")
		
		#check ground
		var ground = _ref_DungeonBoard.get_ground(x, y)
		if ground == -1:
			print("error ground out of map")
		elif ground ==_new_GroundName.STONE:
			print("walked on a stone")	
			emit_signal("pc_moved", "walked on a stone.")		
			
			
		
		#change map
		if x==_ref_DungeonBoard.next_level[0] and y==_ref_DungeonBoard.next_level[1]:
			_ref_InitWorld.current_level+=1
			_ref_InitWorld.change_map(_ref_InitWorld.current_level,false,false,false)
			
			_pc.position = _new_ConvertCoord.index_to_vector(_ref_DungeonSize.start_x, _ref_DungeonSize.start_y)	
			emit_signal("pc_moved_board",_pc, _new_GroupName.PC,_ref_DungeonSize.start_x,_ref_DungeonSize.start_y)			
	
		
		_ref_Schedule.end_turn()


func _get_new_position(event: InputEvent, source: Array) -> Array:
	var x: int = source[0]
	var y: int = source[1]

	if event.is_action_pressed(_new_InputName.MOVE_LEFT):
		x -= 1
	elif event.is_action_pressed(_new_InputName.MOVE_RIGHT):
		x += 1
	elif event.is_action_pressed(_new_InputName.MOVE_UP):
		y -= 1
	elif event.is_action_pressed(_new_InputName.MOVE_DOWN):
		y += 1

	if event.is_action_pressed(_new_InputName.MOVE_UP_LEFT):
		x -= 1
		y -= 1
	elif event.is_action_pressed(_new_InputName.MOVE_UP_RIGHT):
		x += 1
		y -= 1
	elif event.is_action_pressed(_new_InputName.MOVE_DOWN_LEFT):
		x -= 1
		y += 1
	elif event.is_action_pressed(_new_InputName.MOVE_DOWN_RIGHT):
		x += 1
		y += 1
		
	

	return [x, y]

func die()->void:
	$"../Audio/PlayerDeath".play()
	emit_signal("pc_moved", "[color=purple]You have died.[/color]")
	_ref_PauseMenu.disable_resume()
	_ref_PauseMenu.active(2)
	_ref_PauseMenu.index=2	
	_ref_PauseMenu.deactivate(1)
	_ref_PauseMenu.last_index=1	
	_ref_PauseManager.pause_game()
