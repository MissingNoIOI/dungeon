extends Node2D

const PauseMenu := preload("res://scene/gui/PauseMenu.gd")
var _ref_PauseMenu: PauseMenu

const InitWorld := preload("res://scene/main/InitWorld.gd")
var _ref_InitWorld: InitWorld

const DungeonSize := preload("res://scene/main/DungeonSize.gd")
var _ref_DungeonSize : DungeonSize

signal restart(message)
signal pc_moved_board(message)

var _pc: Sprite

var _new_InputName := preload("res://library/InputName.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_PCStats := preload("res://library/PCStats.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()


func _ready() -> void:
	set_process_unhandled_input(false)
	
func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		set_process_unhandled_input(true)
		
func _unhandled_input(event: InputEvent) -> void:
	#while paused
	if _ref_PauseMenu.is_paused:
		while_paused(event)
		return
	
	#activate pause
	if _is_pause_menu_input(event):
		pause_game()
		return

func _is_pause_menu_input(event: InputEvent) -> bool:
	if event.is_action_pressed(_new_InputName.PAUSE):
		return true
	return false
		
func pause_game() -> void:
	_ref_PauseMenu.is_paused=true	
	_ref_PauseMenu.set_visible(true)
	get_tree().set_pause(true)
	
func while_paused(event: InputEvent) -> void:
	if _is_pause_menu_input(event):
		if  _ref_PauseMenu.index==1: #resume
			_ref_PauseMenu.is_paused=false	
			_ref_PauseMenu.set_visible(false)
			get_tree().set_pause(false)
		elif _ref_PauseMenu.index==2: #restart		
			get_tree().set_pause(false)
			_ref_PauseMenu.is_paused=false	
			_ref_PauseMenu.set_visible(false)			
			_pc.hp=_new_PCStats.HP		
			#_pc.has_armor=false
			#_pc.update_sprite_armor()			
			var old_position=_new_ConvertCoord.vector_to_array(_pc.position)			
			_ref_InitWorld.change_map(1,false,true,true)
			_pc.position=_new_ConvertCoord.index_to_vector(_ref_DungeonSize.start_x,_ref_DungeonSize.start_y)
			emit_signal("pc_moved_board",_pc, _new_GroupName.PC,old_position[0],old_position[1])					
			emit_signal("restart","game restarted",_pc.hp,0)
			
			_ref_InitWorld.current_level=1
			if _pc.die:
				_pc.die=false
				_ref_PauseMenu.enable_resume()
				_ref_PauseMenu.index=1
				_ref_PauseMenu.last_index=2
				_ref_PauseMenu.update_menu()
		#elif _ref_PauseMenu.index==3: #save			
		#	_ref_PauseMenu.save_game(_pc)		
		#elif _ref_PauseMenu.index==4: #load			
		#	_ref_PauseMenu.load_game(_pc)
	elif event.is_action_pressed(_new_InputName.MOVE_UP):
		_ref_PauseMenu.last_index=_ref_PauseMenu.index
		_ref_PauseMenu.index-=1
		if  _ref_PauseMenu.index<1:
			_ref_PauseMenu.index=1
		if _ref_PauseMenu.is_hide_resume() and _ref_PauseMenu.index==1:
			_ref_PauseMenu.index=2
		_ref_PauseMenu.update_menu()
	elif event.is_action_pressed(_new_InputName.MOVE_DOWN):
		_ref_PauseMenu.last_index=_ref_PauseMenu.index
		_ref_PauseMenu.index+=1			
		if  _ref_PauseMenu.index>_ref_PauseMenu.total-1:
			_ref_PauseMenu.index=_ref_PauseMenu.total-1
		_ref_PauseMenu.update_menu()
		
