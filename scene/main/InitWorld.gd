extends Node2D

signal sprite_created(new_sprite)
signal level_changed()

const Player := preload("res://sprite/PC.tscn")
const Zombie := preload("res://sprite/Zombie.tscn")
const Ghost := preload("res://sprite/Ghost.tscn")
const Bat := preload("res://sprite/Bat.tscn")
const Chicken := preload("res://sprite/Chicken.tscn")

const Potion := preload("res://sprite/Potion.tscn")
const Bread := preload("res://sprite/Bread.tscn")
const Candy := preload("res://sprite/Candy.tscn")
const Troll := preload("res://sprite/Troll.tscn")

const Key := preload("res://sprite/Key.tscn")

const IronArmor := preload("res://sprite/IronArmor.tscn")
const WoodArmor := preload("res://sprite/WoodArmor.tscn")
const SilverArmor := preload("res://sprite/SilverArmor.tscn")
const GoldenArmor := preload("res://sprite/GoldenArmor.tscn")

const Stone := preload("res://sprite/Stone.tscn")
const Sword := preload("res://sprite/Sword.tscn")
const Torch := preload("res://sprite/Torch.tscn")
const Knife := preload("res://sprite/Knife.tscn")

var Spawn=preload("res://library/Spawn.gd")

const MapOne := preload("res://map/MapOne.tscn")
const DungeonOne := preload("res://map/DungeonOne.tscn")
const DungeonTwo := preload("res://map/DungeonTwo.tscn")
const DungeonThree := preload("res://map/DungeonThree.tscn")

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
var _ref_DungeonBoard: DungeonBoard

const WallsObject ="/root/MainScene/StaticMap/main-map/walls"
const TransparentObject ="/root/MainScene/StaticMap/main-map/transparent"
const DecoMap ="/root/MainScene/StaticMap/main-map/DecoMap"
const FloorMap ="/root/MainScene/StaticMap/main-map/FloorMap"
const DungeonObjects ="/root/MainScene/StaticMap/main-map/DungeonObjects"


const FOV := preload("res://scene/main/FOV.gd")
var _ref_FOV : FOV

const DungeonSize := preload("res://scene/main/DungeonSize.gd")
var _ref_DungeonSize : DungeonSize

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()
var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_InputName := preload("res://library/InputName.gd").new()
var _new_Types := preload("res://library/Types.gd").new()

var _rng := RandomNumberGenerator.new()

var tileset_texture :Texture
const TILESET_STEP:int = 16

var wall_transparent=Vector2(52,30)#wall not player passing but seeing

var current_level:int = 1

var boss_spawner

func _ready() -> void:
	# _rng.seed = 123
	_rng.randomize()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(_new_InputName.INIT_WORLD):
		
		change_map(1,true,true,true)
		
		set_process_unhandled_input(false)

func init_world(without_monsters:bool,without_fov:bool)->void:
	

	_init_wall_and_ground()
	_init_objects()
	
	if !without_monsters:
		init_enemies()
		
		var _r: int = _rng.randi_range(0,3)
		match(_r):
			0:
				_init_item(Spawn.ItemSpawner.new(Chicken),0,1)
			1:
				_init_item(Spawn.ItemSpawner.new(Potion),0,1)
			2:
				_init_item(Spawn.ItemSpawner.new(Bread),0,1)
			3:
				_init_item(Spawn.ItemSpawner.new(Candy),0,1)
			
		var _r2: int = _rng.randi_range(0,3)
		match(_r2):
			0:
				_init_item(Spawn.ItemSpawner.new(IronArmor),0,1)
			1:
				_init_item(Spawn.ItemSpawner.new(WoodArmor),0,1)
			2:
				_init_item(Spawn.ItemSpawner.new(SilverArmor),0,1)
			3:
				_init_item(Spawn.ItemSpawner.new(GoldenArmor),0,1)
		var _r3: int = _rng.randi_range(0,3)
		match(_r3):
			0:
				_init_item(Spawn.ItemSpawner.new(Stone),1,1)
			1:
				_init_item(Spawn.ItemSpawner.new(Sword),1,1)
			2:
				_init_item(Spawn.ItemSpawner.new(Torch),1,1)
			3:
				_init_item(Spawn.ItemSpawner.new(Knife),1,1)
		

	if !without_fov:
		_ref_FOV.init_fov()
	else:
		_ref_FOV.initiated=false
	
func _init_boss(spawner:Spawn.EnemySpawner,x:int,y:int) -> void:
	var spr:Sprite = spawner.spawn_enemy()
	spr.set_name("Troll")
	_create_sprite(spr,_new_GroupName.ZOMBIE,x,y)
func init_enemies():
	var array=_new_Types.types.get("enemies")
	for e in array:
		match (e.get("name")):
			"Zombie":
				_init_enemy("Zombie",Spawn.EnemySpawner.new(Zombie,e.get("hp"),e.get("speed"),e.get("strength"),e.get("dexterity"),e.get("attack"),e.get("weakness")),0,2)
			"Ghost":
				_init_enemy("Ghost",Spawn.EnemySpawner.new(Ghost,e.get("hp"),e.get("speed"),e.get("strength"),e.get("dexterity"),e.get("attack"),e.get("weakness")),0,2)
			"Bat":
				_init_enemy("Bat",Spawn.EnemySpawner.new(Bat,e.get("hp"),e.get("speed"),e.get("strength"),e.get("dexterity"),e.get("attack"),e.get("weakness")),0,2)
			"Troll":
				boss_spawner=Spawn.EnemySpawner.new(Troll,e.get("hp"),e.get("speed"),e.get("strength"),e.get("dexterity"),e.get("attack"),e.get("weakness"))
			_:
				#print("pass")
				#print(e.get("name"))
				pass

func _init_item(spawner:Spawn.ItemSpawner,minim:int,maxim:int) -> void:
	var item: int = _rng.randi_range(minim,maxim)

	for _i in range(0,item):
		var array=random_position()
		var spr:Sprite = spawner.spawn_item()
		_create_sprite(spr,_new_GroupName.ITEM,array[0],array[1])
		
func _init_enemy(name:String,spawner:Spawn.EnemySpawner,minim:int,maxim:int) -> void:
	var enemy: int = _rng.randi_range(minim, maxim)

	for _i in range(0,enemy):
		var array=random_position()
		var spr:Sprite = spawner.spawn_enemy()
		spr.set_name(name)		
		_create_sprite(spr,_new_GroupName.ZOMBIE,array[0],array[1])

	
func random_position() -> Array:
	var x: int
	var y: int

	while true:
		x = _rng.randi_range(1, _ref_DungeonSize.max_x - 1)
		y = _rng.randi_range(1, _ref_DungeonSize.max_y - 1)
		
		if _ref_DungeonBoard.is_wall(x, y) or _ref_DungeonBoard.is_transparent_wall(x, y) or _ref_DungeonBoard.has_sprite(_new_GroupName.ZOMBIE, x, y):
			continue
		return [x,y]

					
#load walls from tilemap if the subtiles are in the collision array of subtiles
func _init_wall_and_ground() -> void:
	_ref_DungeonBoard.clear_wall()
	_ref_DungeonBoard.clear_ground()
	
	var tilemap_deco=get_node(DecoMap)
	var tilemap_floor=get_node(FloorMap)
	
	var tileset = tilemap_floor.tile_set
	if tileset.has_meta("tile_meta"):
		var tile_meta=tileset.get_meta("tile_meta")
		#print("has meta", tile_meta)
		for i in tile_meta:
			if tile_meta[i].has('transparent'):
				var array_trans =tilemap_floor.get_used_cells_by_id(i)
				for j in array_trans:
					_ref_DungeonBoard.create_transparent_wall(j.x,j.y)
			if tile_meta[i].has('wall'):
				var array_wall =tilemap_floor.get_used_cells_by_id(i)
				for j in array_wall:
					_ref_DungeonBoard.create_wall(j.x,j.y)
			if tile_meta[i].has('stone'):
				var array_stone =tilemap_floor.get_used_cells_by_id(i)
				for j in array_stone:
					_ref_DungeonBoard.create_ground_stone(j.x,j.y)
					
	var tileset2 = tilemap_deco.tile_set
	if tileset2.has_meta("tile_meta"):
		var tile_meta=tileset2.get_meta("tile_meta")
		#print("has meta", tile_meta)
		for i in tile_meta:
			if tile_meta[i].has('transparent'):
				var array_trans =tilemap_deco.get_used_cells_by_id(i)
				for j in array_trans:
					_ref_DungeonBoard.create_transparent_wall(j.x,j.y)
			if tile_meta[i].has('wall'):
				var array_wall =tilemap_deco.get_used_cells_by_id(i)
				for j in array_wall:
					_ref_DungeonBoard.create_wall(j.x,j.y)
			if tile_meta[i].has('stone'):
				var array_stone =tilemap_deco.get_used_cells_by_id(i)
				for j in array_stone:
					_ref_DungeonBoard.create_ground_stone(j.x,j.y)
	
func _init_objects() -> void:
	var tilemap_floor=get_node(FloorMap)
	var tileset = tilemap_floor.tile_set
	
	if has_node(DungeonObjects):
		var dungeon_objects=get_node(DungeonObjects)
		
		for i in dungeon_objects.get_children():
			var array=_new_ConvertCoord.vector_to_array(i.position)
			var type = i.get_meta('type')
			match(type):
				'chest':
					var tile_id=i.get_meta('tile_id') +1
					var new_sprite: Chest = Chest.new()
					new_sprite.set_texture(tileset.tile_get_texture(tile_id))
					new_sprite.region_enabled=true
					new_sprite.set_region_rect(tileset.tile_get_region(tile_id))
					new_sprite.position = _new_ConvertCoord.index_to_vector(array[0],array[1], 0, 0)
					new_sprite.add_to_group(_new_GroupName.CHEST)
					new_sprite.z_index=1
					
					var open_id=i.get_meta('open_chest_id') +1
					var open_sprite: Sprite = Sprite.new()
					open_sprite.set_texture(tileset.tile_get_texture(open_id))
					open_sprite.region_enabled=true
					open_sprite.set_region_rect(tileset.tile_get_region(open_id))
					open_sprite.hide()
					open_sprite.name="OpenSprite"
					new_sprite.add_child(open_sprite)
					open_sprite.set_owner(new_sprite)
					
					print(open_sprite.name)
					
					_create_sprite(new_sprite,_new_GroupName.CHEST,array[0],array[1])
					print("chest:",array[0],",",array[1])
					
				'door':
					var tile_id=i.get_meta('tile_id') +1
					var new_sprite: Door = Door.new()
					new_sprite.set_texture(tileset.tile_get_texture(tile_id))
					new_sprite.region_enabled=true
					new_sprite.set_region_rect(tileset.tile_get_region(tile_id))
					new_sprite.position = _new_ConvertCoord.index_to_vector(array[0],array[1], 0, 0)
					new_sprite.add_to_group(_new_GroupName.DOOR)
					new_sprite.z_index=1
					
					var open_id=i.get_meta('open_door_id') +1
					var open_sprite: Sprite = Sprite.new()
					open_sprite.set_texture(tileset.tile_get_texture(open_id))
					open_sprite.region_enabled=true
					open_sprite.set_region_rect(tileset.tile_get_region(open_id))
					open_sprite.hide()
					open_sprite.name="OpenSprite"
					new_sprite.add_child(open_sprite)
					open_sprite.set_owner(new_sprite)
					
					print(open_sprite.name)
					
					_create_sprite(new_sprite,_new_GroupName.DOOR,array[0],array[1])										
					print("door:",array[0],",",array[1])
				'gold':
					print("gold(",i.get_meta('amount'),"):",array[0],",",array[1])
				'boss':
					print("boss:",array[0],",",array[1])	
					_init_boss(boss_spawner,array[0],array[1])			
				'stairs_up':
					print("stairs up:",array[0],",",array[1])
					_ref_DungeonSize.start_x=array[0]
					_ref_DungeonSize.start_y=array[1]
				'stairs_down':
					print("stairs down:",array[0],",",array[1])
					_ref_DungeonBoard.next_level=array
				_:
					continue
	
func _get_subtile_coord(id,tileset):
	var rect = tileset.tile_get_region(id)
	return Vector2(rect.x, rect.y)
	
func _create_sprite(sprite: Sprite, group: String, x: int, y: int) -> void:

	sprite.position = _new_ConvertCoord.index_to_vector(
		x, y, 0, 0)
	sprite.add_to_group(group)

	add_child(sprite)
	sprite.set_owner(self)
	
	emit_signal("sprite_created", sprite)

func _create_sprite_key(x: int, y: int) -> void:

	var new_sprite: Sprite = Key.instance() as Sprite
	_create_sprite(new_sprite,_new_GroupName.ITEM,x,y)

func _create_sprite_from_group(group: String, x: int, y: int,subgroup: String) -> void:
	if group ==_new_GroupName.ZOMBIE:
		var array=_new_Types.types.get("enemies")
		var ghost
		var bat
		var troll
		var zombie
		for e in array:
			if e.get("name")=="Ghost":
				ghost=e
			if e.get("name")=="Bat":
				bat=e
			if e.get("name")=="Troll":
				troll=e
			if e.get("name")=="Zombie":
				zombie=e
				#print("zombie")						
		if subgroup=="Ghost":
			_create_sprite(Spawn.EnemySpawner.new(Ghost,ghost.get("hp"),ghost.get("speed"),ghost.get("strength"),ghost.get("dexterity"),ghost.get("attack")).spawn_enemy(),_new_GroupName.ZOMBIE, x, y)
		elif subgroup=="Bat":
			_create_sprite(Spawn.EnemySpawner.new(Bat,bat.get("hp"),bat.get("speed"),bat.get("strength"),bat.get("dexterity"),bat.get("attack")).spawn_enemy(),_new_GroupName.ZOMBIE, x, y)
		elif subgroup=="Troll":
			_create_sprite(Spawn.EnemySpawner.new(Troll,troll.get("hp"),troll.get("speed"),troll.get("strength"),troll.get("dexterity"),troll.get("attack")).spawn_enemy(),_new_GroupName.ZOMBIE, x, y)
		else:
			_create_sprite(Spawn.EnemySpawner.new(Zombie,zombie.get("hp"),zombie.get("speed"),zombie.get("strength"),zombie.get("dexterity"),zombie.get("attack")).spawn_enemy(),_new_GroupName.ZOMBIE, x, y)

	elif group ==_new_GroupName.ITEM:
		if subgroup=="Chicken":
			_create_sprite(Spawn.ItemSpawner.new(Chicken).spawn_item(),_new_GroupName.ITEM, x, y)
		elif subgroup=="IronArmor":
			_create_sprite(Spawn.ItemSpawner.new(IronArmor).spawn_item(),_new_GroupName.ITEM, x, y)

#number -> map to load
#new -> new pc to load
#without_monsters -> load monsters or not
func change_map(number:int,new_pc:bool,without_monsters:bool,without_fov:bool)->void:
	var node=get_node("/root/MainScene")


	#clear current
	emit_signal("level_changed")
	if !new_pc:
		_ref_DungeonBoard.clear_map()

			

	if !new_pc:
		var node_removed:Node2D=get_node("/root/MainScene/StaticMap")
		#unload current	
		node.remove_child(node_removed)
		node_removed.queue_free()
	
	var node_added:Node2D
	#load new
	match(number):
		1:
			node_added=MapOne.instance() as Node2D
		2:
			node_added=DungeonOne.instance() as Node2D
		3:
			node_added=DungeonTwo.instance() as Node2D
		4:
			node_added=DungeonThree.instance() as Node2D
		_:
			node_added=DungeonOne.instance() as Node2D #NOT TO CHANGE TO MAPONE	(because mapone has no fov an cause runtime error)
			current_level=1
			
	node.add_child(node_added)
	node_added.set_owner(node)
	

		
	
	#update the level variables
	_ref_DungeonSize.max_x=node_added.MAX_X
	_ref_DungeonSize.max_y=node_added.MAX_Y
	
#	_ref_DungeonBoard.next_level=node_added.get_next_level_position()
#	var start=node_added.get_start_position()
#	_ref_DungeonSize.start_x=start[0]
#	_ref_DungeonSize.start_y=start[1]
#	if !without_monsters:
#		var boss=node_added.get_boss_position()
#		_ref_DungeonSize.boss_x=boss[0]
#		_ref_DungeonSize.boss_y=boss[1]
#	_ref_DungeonSize.clearArea=node_added.get_clear_area()
	_ref_DungeonBoard.init_dungeon()
	
		
	
	#init new	
	init_world(without_monsters,without_fov)
	
	if new_pc:
		_create_sprite(Player.instance(),_new_GroupName.PC,_ref_DungeonSize.start_x,_ref_DungeonSize.start_y)
		if !without_fov:
			_ref_FOV.fov()
			
	$"../Audio/BackgroundMusic".play_random()
	
