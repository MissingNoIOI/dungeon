extends Node2D


const Ghost := preload("res://sprite/spritescripts/GhostScript.gd")
const Bat := preload("res://sprite/spritescripts/BatScript.gd")
const Troll := preload("res://sprite/spritescripts/TrollScript.gd")
const Chicken := preload("res://sprite/spritescripts/ChickenScript.gd")
const IronArmor := preload("res://sprite/spritescripts/IronArmorScript.gd")

var _new_GroupName := preload("res://library/GroupName.gd").new()


const DungeonSize := preload("res://scene/main/DungeonSize.gd")
var _ref_DungeonSize:DungeonSize

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")
var _ref_DungeonBoard: DungeonBoard

const RemoveObject := preload("res://scene/main/RemoveObject.gd")
var _ref_RemoveObject: RemoveObject

const InitWorld := preload("res://scene/main/InitWorld.gd")
var _ref_InitWorld: InitWorld

const Schedule := preload("res://scene/main/Schedule.gd")
var _ref_Schedule: Schedule

const Sidebar:= preload("res://scene/gui/SidebarVBox.gd")
var _ref_Sidebar: Sidebar

var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

var groups = [_new_GroupName.ZOMBIE, _new_GroupName.ITEM]

signal pc_moved_board(message)
signal load_game(message)
# Note: This can be called from anywhere inside the tree. This function is
# path independent.
func save_game(_pc):
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	#line for PC
	var array=_new_ConvertCoord.vector_to_array(_pc.position)
	var store_armor:int=0
	#if _pc.has_armor:
	#	store_armor=1
	var store_key:int=0
	if _pc.has_key:
		store_key=1
	save_game.store_line(String(array[0])+"|"+String(array[1])+"#"+String(_pc.hp)+"$"+String(_ref_Sidebar._turn_counter)+"@"+String(_ref_InitWorld.current_level)+"!"+String(store_armor)+"%"+String(store_key)+"~")
	for g in groups:
		for x in range(_ref_DungeonSize.max_x):
			for y in range(_ref_DungeonSize.max_y):
				var sprite=_ref_DungeonBoard._sprite_dict[g][x][y]
				if sprite==null:
					continue	
				elif sprite.is_in_group(_new_GroupName.ZOMBIE):
					if sprite is Ghost:
						save_game.store_line(String(g) + "|" + String(x)  + "#" + String(y)+"$"+"Ghost")
						continue
					elif sprite is Bat:
						save_game.store_line(String(g) + "|" + String(x)  + "#" + String(y)+"$"+"Bat")
						continue						
					elif sprite is Troll:
						save_game.store_line(String(g) + "|" + String(x)  + "#" + String(y)+"$"+"Troll")
						continue			
				elif sprite.is_in_group(_new_GroupName.ITEM):
					if sprite is Chicken:
						save_game.store_line(String(g) + "|" + String(x)  + "#" + String(y)+"$"+"Chicken")
						continue
					elif sprite is IronArmor:
						save_game.store_line(String(g) + "|" + String(x)  + "#" + String(y)+"$"+"IronArmor")
						continue
				
				save_game.store_line(String(g) + "|" + String(x)  + "#" + String(y)+"$")
	save_game.close()
	
	
# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game(_pc):
	var save_game = File.new()
	var turn
	var hp
	var level
	var armor:int
	var key:int
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
		
		
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open("user://savegame.save", File.READ)
	var num=0
	while save_game.get_position() < save_game.get_len():
		num+=1
		# Get the saved dictionary from the next line in the save file
		var data = save_game.get_line()
		if num==1:#line 1 -> pc position
			var j
			var k
			var l
			var v
			var w
			var u
			var q
			for i in range(0,data.length()):
				if data[i]=='|':
					j=i
				if data[i]=='#':
					k=i
				if data[i]=='$':
					l=i
				if data[i]=='@':
					v=i				
				if data[i]=='!':
					w=i
				if data[i]=='%':
					u=i
				if data[i]=='~':
					q=i
			var x=int(data.substr(0,j))
			var y=int(data.substr(j+1,k-j))
			hp=int(data.substr(k+1,l-k))
			turn=int(data.substr(l+1,v-l))
			level=int(data.substr(v+1,w-v))
			armor=int(data.substr(w+1,u-w))			
			key=int(data.substr(u+1,q-u))			
			
			
			#set hp
			_pc.hp=hp
			_pc.die=false
			if armor==1:
				_pc.has_armor=true
			else:
				_pc.has_armor=false
			if key==1:
				_pc.has_key=true
			else:
				_pc.has_key=false
			#_pc.update_sprite_armor()
			#set level
			_ref_InitWorld.current_level=level	
			_ref_DungeonBoard.clear_map()	
			_ref_Schedule.clear_schedule()
			
			if level==1:
				_ref_InitWorld.change_map(level,false,true,true)#without fov				
			else:
				_ref_InitWorld.change_map(level,false,true,false)#with fov
			
			#set_pc position
			var old_position=_new_ConvertCoord.vector_to_array(_pc.position)
			_pc.position = _new_ConvertCoord.index_to_vector(x, y)	
			emit_signal("pc_moved_board",_pc, _new_GroupName.PC,old_position[0],old_position[1])
			
			
			continue
		var group
		var subgroup=""
		var x
		var y		
		var j
		var k
		var l
		#other lines ZOMBIEs and items		
		for i in range(0,data.length()):
			if data[i]=='|':
				j=i
			if data[i]=='#':
				k=i
			if data[i]=='$':
				l=i	
		group=data.substr(0,j)		
		x=int(data.substr(j+1,k-j))					
		y=int(data.substr(k+1,l-k))
		if group==_new_GroupName.ZOMBIE or group==_new_GroupName.ITEM:
			subgroup=data.substr(l+1,data.length()-l)
					
		_ref_InitWorld._create_sprite_from_group(group,x,y,subgroup)
	save_game.close()
	
	
	
	emit_signal("load_game","game loaded",hp,turn)
