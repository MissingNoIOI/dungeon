extends Node2D

const DungeonSize := preload("res://scene/main/DungeonSize.gd")
var _ref_DungeonSize:DungeonSize

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroundName := preload("res://library/GroundName.gd").new()

# <string_group_name, <int_column, array_sprite>>
var _sprite_dict: Dictionary

var _array_wall=[]
var _array_ground=[]


var initiated:bool =false

const WALL:=1
const FREE:=0
const WALL_TRANSPARENT:=2

var next_level:Array

func init_dungeon() -> void:
	#if !initiated:
	#	initiated=true
	_init_dict()
	init_wall()
	init_ground()

func init_ground()->void:
	_array_ground.resize(_ref_DungeonSize.max_x)
	for x in range(_ref_DungeonSize.max_x):
		_array_ground[x]=[]
		_array_ground[x].resize(_ref_DungeonSize.max_y)
		

func clear_ground()->void:
	for x in range(_ref_DungeonSize.max_x):
		for y in range(_ref_DungeonSize.max_y):
			_array_ground[x][y]=_new_GroundName.PLAIN

func init_wall()->void:
	_array_wall.resize(_ref_DungeonSize.max_x)
	for x in range(_ref_DungeonSize.max_x):
		_array_wall[x]=[]
		_array_wall[x].resize(_ref_DungeonSize.max_y)

func clear_wall()->void:
	for x in range(_ref_DungeonSize.max_x):
		for y in range(_ref_DungeonSize.max_y):
			_array_wall[x][y]=FREE

func create_wall(x:int,y:int)->void:
	if !is_inside_dungeon(x,y):
		return
	_array_wall[x][y]=WALL

func create_ground_stone(x:int,y:int)->void:
	if !is_inside_dungeon(x,y):
		return
	_array_ground[x][y]=_new_GroundName.STONE

func create_transparent_wall(x:int,y:int)->void:
	if !is_inside_dungeon(x,y):
		return
	_array_wall[x][y]=WALL_TRANSPARENT

func get_ground(x:int,y:int)->int:	
	if is_inside_dungeon(x,y):
		return _array_ground[x][y]		
	return -1

func is_wall(x:int,y:int)->bool:	
	if is_inside_dungeon(x,y) and _array_wall[x][y]==WALL:
		return true
	return false

func is_transparent_wall(x:int,y:int)->bool:	
	if is_inside_dungeon(x,y) and _array_wall[x][y]==WALL_TRANSPARENT:
		return true
	return false

func is_inside_dungeon(x: int, y: int) -> bool:
	return (x > -1) and (x < _ref_DungeonSize.max_x) \
			and (y > -1) and (y < _ref_DungeonSize.max_y)


func has_sprite(group_name: String, x: int, y: int) -> bool:
	return get_sprite(group_name, x, y) != null


func get_sprite(group_name: String, x: int, y: int) -> Sprite:
	if not is_inside_dungeon(x, y):
		return null
	return _sprite_dict[group_name][x][y]


func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	var pos: Array
	var group: String

	if new_sprite.is_in_group(_new_GroupName.ZOMBIE):
		group = _new_GroupName.ZOMBIE
	elif new_sprite.is_in_group(_new_GroupName.ITEM):
		group = _new_GroupName.ITEM
	elif new_sprite.is_in_group(_new_GroupName.CHEST):
		group = _new_GroupName.CHEST
	elif new_sprite.is_in_group(_new_GroupName.DOOR):
		group = _new_GroupName.DOOR
	else:
		return

	pos = _new_ConvertCoord.vector_to_array(new_sprite.position)
	_sprite_dict[group][pos[0]][pos[1]] = new_sprite

func _on_RemoveObject_sprite_removed(_sprite: Sprite, group_name: String,
		x: int, y: int) -> void:
	_sprite_dict[group_name][x][y] = null

#move the enemy in the internal board array
func _on_EnemyAI_enemy_moved_board(_sprite: Sprite, group_name: String,
		old_x: int, old_y: int) -> void:
	_sprite_dict[group_name][old_x][old_y] = null
	var pos = _new_ConvertCoord.vector_to_array(_sprite.position)
	_sprite_dict[group_name][pos[0]][pos[1]] = _sprite

#move the pc in the internal board array
func _on_PCMove_pc_moved_board(_sprite: Sprite, group_name: String,
		old_x: int, old_y: int) -> void:
	if is_inside_dungeon(old_x,old_y):#this is because of various level sizes(the old position can be in previous level out of limits in the actual level)
		_sprite_dict[group_name][old_x][old_y] = null
	var pos = _new_ConvertCoord.vector_to_array(_sprite.position)
	_sprite_dict[group_name][pos[0]][pos[1]] = _sprite
	
func _on_SaveLoadManager_pc_moved_board(_sprite: Sprite, group_name: String,
		old_x: int, old_y: int):
	_on_PCMove_pc_moved_board(_sprite, group_name,old_x, old_y)



func clear_map() ->void:
	var groups = [_new_GroupName.ZOMBIE,_new_GroupName.ITEM,_new_GroupName.CHEST,_new_GroupName.DOOR]
	for g in groups:
		for x in range(0,_ref_DungeonSize.max_x):
			for y in range(0,_ref_DungeonSize.max_y):
				if _sprite_dict[g][x][y]!=null:	
					_sprite_dict[g][x][y].queue_free() 
				_sprite_dict[g][x][y] = null
				

func _init_dict() -> void:
	var groups = [_new_GroupName.ZOMBIE, _new_GroupName.PC,_new_GroupName.ITEM,_new_GroupName.CHEST,_new_GroupName.DOOR]
	for g in groups:
		_sprite_dict[g] = {}
		for x in range(_ref_DungeonSize.max_x):
			_sprite_dict[g][x] = []
			_sprite_dict[g][x].resize(_ref_DungeonSize.max_y)
