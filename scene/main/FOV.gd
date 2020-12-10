extends Node2D


const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

const DungeonSize := preload("res://scene/main/DungeonSize.gd")
var _ref_DungeonSize : DungeonSize


var _ref_DungeonBoard: DungeonBoard

var _pc: Sprite

const VIEW_RADIUS:int =150
const TOTAL_RADIUS_X:int =13
const TOTAL_RADIUS_Y:int =10


var _array_color=[]

var initiated:bool =false

func init_fov()->void:
	if !initiated:
		initiated=true
	_array_color.resize(_ref_DungeonSize.max_x)
	for x in range(_ref_DungeonSize.max_x):
		_array_color[x]=[]
		_array_color[x].resize(_ref_DungeonSize.max_y)
	
	for x in range(_ref_DungeonSize.max_x):
		for y in range(_ref_DungeonSize.max_y):
			if clear_area(_new_ConvertCoord.index_to_vector(x,y)):
				_array_color[x][y]=Color(0,0,0,0)
			else:
				_array_color[x][y]=Color(0,0,0,1.0)

func fov() -> void:	
	if !initiated:
		return
	var x:float
	var y:float	
	set_viewport_not_visible(TOTAL_RADIUS_X,TOTAL_RADIUS_Y)
	for i in range(0,360):
		x=cos(i*0.01745)
		y=sin(i*0.01745)
		do_fov(x,y)
	update() #updates de primitives(call to _draw())

func set_viewport_not_visible(radius_x,radius_y) -> void:
	var array : Array=_new_ConvertCoord.vector_to_array(_pc.position)
	var center_x:int =array[0]
	var center_y:int =array[1]
	for x in range(center_x-radius_x+1,center_x+radius_x):
		for y in range(center_y-radius_y+1,center_y+radius_y):
			if !is_in_range(x,y):
				continue
			if _array_color[x][y].a==0:
				_array_color[x][y].a=0.5
			elif _array_color[x][y].a==0.5:
				_array_color[x][y].a=0.5
			else:
				_array_color[x][y].a=1
		
func do_fov(x:float, y:float) -> void:	
	var ox:float
	var oy:float	
	var array:Array =_new_ConvertCoord.vector_to_array(_pc.position)
	ox = array[0]+0.5
	oy = array[1]+0.5

			
# warning-ignore:unused_variable
	for i in range(0,VIEW_RADIUS,16):				
		if(!is_in_range(int(ox),int(oy))):
			ox+=x
			oy+=y
			continue
		_array_color[int(ox)][int(oy)]=Color(0,0,0,0)#set the tile visible
		if _ref_DungeonBoard.is_wall(int(ox),int(oy)) or  _ref_DungeonBoard.get_sprite(_new_GroupName.ZOMBIE,int(ox),int(oy))!=null or _ref_DungeonBoard.get_sprite(_new_GroupName.DOOR,int(ox),int(oy))!=null:
			return
		ox+=x
		oy+=y

func _on_InitWorld_sprite_created(new_sprite: Sprite) -> void:
	if new_sprite.is_in_group(_new_GroupName.PC):
		_pc = new_sprite
		
func _on_PCMove_pc_moved_board(_sprite: Sprite, _group_name: String,
		_old_x: int, _old_y: int) -> void:
	fov()
func _on_PCAttack_pc_attacked(_message:String) -> void:
	fov()
func _on_SaveLoadManager_pc_moved_board(_sprite: Sprite, _group_name: String,
		_old_x: int, _old_y: int):
	#if _ref_InitWorld.current_level!=1:  #HAVE TO FIX THIS(if level 1 there are no fov)
	fov()

func _draw():
	if _pc!=null:		
		var array : Array=_new_ConvertCoord.vector_to_array(_pc.position)
		var center_x:int =array[0]
		var center_y:int =array[1]
		for x in range(center_x-TOTAL_RADIUS_X+1,center_x+TOTAL_RADIUS_X):
			for y in range(center_y-TOTAL_RADIUS_Y+1,center_y+TOTAL_RADIUS_Y):
					if(!is_in_range(x,y)):
						continue
					var pos=_new_ConvertCoord.index_to_vector(x,y)
#warning-ignore:integer_division
					pos.x-=_new_ConvertCoord.STEP_X/2
#warning-ignore:integer_division
					pos.y-=_new_ConvertCoord.STEP_Y/2
					var rect = Rect2(pos,Vector2(_new_ConvertCoord.STEP_X,_new_ConvertCoord.STEP_Y))
					var color = _array_color[x][y]
					draw_rect(rect, color)					

func is_in_fov(x,y)->bool:
	if _array_color[x][y].a==0:
		return false
	else:
		return true

func is_in_range(x,y)->bool:
	if x<0 or x>=_ref_DungeonSize.max_x:
		return false
	if y<0 or y>=_ref_DungeonSize.max_y:
		return false
	return true
	
func clear_area(position:Vector2) -> bool:
	var pol=_ref_DungeonSize.clearArea
	if pol==null:
		return false
	return polygon_ray_casting(pol,position)


func polygon_ray_casting(pol:Polygon2D, position:Vector2)-> bool:
	
	# Arrays containing the x- and y-coordinates of the polygon's vertices.
	var array:=pol.polygon 	
	# Number of vertices in the polygon
	var nvert =array.size()
	var position_inside=false
	var testx = position.x
	var testy = position.y
	var c = 0
	for i in range(0, nvert):
		var j = i - 1 if i != 0 else nvert - 1
		if( ((array[i].y > testy ) != (array[j].y > testy))   and
			(testx < (array[j].x - array[i].x) * (testy - array[i].y) / (array[j].y - array[i].y) + array[i].x) ):
			c += 1
	# If odd, that means that we are inside the polygon
	if c % 2 == 1: 
		position_inside=true

	
	return position_inside
