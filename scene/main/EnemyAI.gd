extends Node2D


const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
const Schedule := preload("res://scene/main/Schedule.gd")
const Enemy := preload("res://sprite/spritescripts/EnemyScript.gd")
const FOV := preload("res://scene/main/FOV.gd")

var _ref_Schedule: Schedule
var _ref_DungeonBoard: DungeonBoard
var _ref_FOV: FOV

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()


const ENEMY_ATTACK: String = "EnemyAttack"

var _pc: Sprite

signal enemy_warned(message)
signal enemy_moved_board(message)

const EnemyAS: String = "EnemyAS"

var result: PoolIntArray 

func _on_Schedule_turn_started(current_sprite: Sprite) -> void:	
	if not current_sprite.is_in_group(_new_GroupName.ZOMBIE):
		return
	
	if _pc_is_very_close(_pc, current_sprite):		
		get_node(ENEMY_ATTACK).attack(current_sprite,_pc)
		return
	var pos=_new_ConvertCoord.vector_to_array(current_sprite.position)
	if not _ref_FOV.is_in_fov(pos[0],pos[1]):	
		if !current_sprite.is_alerted():#alert the enemy
			emit_signal("enemy_warned", "[color=yellow]Enemy is alerted![/color]")			
			current_sprite.set_alerted(true)
		elif !_pc_is_close(_pc,current_sprite):#stop to follow
			_ref_Schedule.end_turn()
			current_sprite.set_alerted(false)
			return
	
	if current_sprite.is_alerted():#follow the pc
		get_node(EnemyAS).create_graph(_new_ConvertCoord.vector_to_array(current_sprite.position),_new_ConvertCoord.vector_to_array(_pc.position))
		result = get_node(EnemyAS).get_astar_path() as PoolIntArray
		
		#result stores the navigation path
		if result!=null and result.size()>1:#remove the first point navigation itself
			result.remove(0)
		else:
			print("enemy no navigation error 1")
			_ref_Schedule.end_turn()
			return
		if result!=null and result.size()>0:
			var new_position=get_node(EnemyAS).astar.get_point_position(result[0])			
			var old_position=_new_ConvertCoord.vector_to_array(current_sprite.position)
						
			_try_move(current_sprite,old_position,new_position.x, new_position.y)												
						
			return	
		else:
			print("enemy no navigation error 2")
			_ref_Schedule.end_turn()
			return
	else:#if not alerted
		_ref_Schedule.end_turn()		
	return


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite


func _pc_is_close(source: Sprite, target: Sprite) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int

	return delta_x + delta_y < 10
	
	
	#is the enemy touching the player
func _pc_is_very_close(source: Sprite, target: Sprite) -> bool:
	var source_pos: Array = _new_ConvertCoord.vector_to_array(source.position)
	var target_pos: Array = _new_ConvertCoord.vector_to_array(target.position)
	var delta_x: int = abs(source_pos[0] - target_pos[0]) as int
	var delta_y: int = abs(source_pos[1] - target_pos[1]) as int

	return delta_x<=1 and delta_y <= 1

	
func _try_move(current_sprite: Sprite,old_position:Array,x: int, y: int) -> void:
	current_sprite = current_sprite as Enemy #convert type EnemyScript
	if not _ref_DungeonBoard.is_inside_dungeon(x, y):		
		print("error: the monster shouldn't leave the map")
		_ref_Schedule.end_turn()
	elif _ref_DungeonBoard.is_wall(x, y) or _ref_DungeonBoard.is_transparent_wall(x, y):
		print("error: the monster shouldn't walk on the walls")
		_ref_Schedule.end_turn()
	elif _ref_DungeonBoard.has_sprite(_new_GroupName.ZOMBIE, x, y):
		print("error: the monster shouldn't walk on others Zombies")
		_ref_Schedule.end_turn()
	else:		
		current_sprite.set_stamina(current_sprite.get_stamina()+current_sprite.speed)		
		if current_sprite.get_stamina()>=100:								
			current_sprite.set_stamina(current_sprite.get_stamina()-100)
			#if have enought stamina move the player
			current_sprite.position = _new_ConvertCoord.index_to_vector(x, y)			
		emit_signal("enemy_moved_board", current_sprite,_new_GroupName.ZOMBIE,old_position[0],old_position[1])
		_ref_Schedule.end_turn()
