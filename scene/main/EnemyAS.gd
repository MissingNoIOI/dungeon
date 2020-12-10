extends Node2D

const DungeonBoard := preload("res://scene/main/DungeonBoard.gd")

var _new_GroupName := preload("res://library/GroupName.gd").new()
var _new_ConvertCoord := preload("res://library/ConvertCoord.gd").new()

var _ref_DungeonBoard: DungeonBoard

var id_player:int
var id_enemy:int

var astar = AStar2D.new()
const WEIGHT_GREAT : float =100.0

const LEFT_CELL:int = -10
const RIGHT_CELL:int = 9
const TOP_CELL:int = -10
const BOTTOM_CELL:int = 9

const FIRST_ID:int=0
const LAST_ID:int=360#(total (19*19)-1)

const RIGHT_ID:int=1
const BOTTOM_ID:int=19
const BOTTOM_RIGHT_ID:int=20
const UP_RIGHT_ID:int=-18

const LAST_COLUMN:int=19
const TOTAL_COLUMNS:int=20
const FIRST_ROW_PLUS_ONE:int=1
const LAST_ROW_MINUS_TWO:int=17





func create_graph(source: Array, target: Array):
	var x: int = source[0]
	var y: int = source[1]
	var x2: int = target[0]
	var y2: int = target[1]
	var num=0
	astar.clear()
	
	#square 19 by 19 side with the enemy in the center
	#think that there are (19*19) 361 nodes graph (very expensive)
	for j in range(y+TOP_CELL,y+BOTTOM_CELL):#center counts too			
		for i in range(x+LEFT_CELL,x+RIGHT_CELL):#center counts too
			
			if _ref_DungeonBoard.has_sprite(_new_GroupName.ZOMBIE,i,j) or _ref_DungeonBoard.is_wall(i,j) or (x2==i and y2==j):
				astar.add_point(num, Vector2(i, j),WEIGHT_GREAT)#add point of wall with more weight
			else:
				astar.add_point(num, Vector2(i, j))#add points to graph
			
			if x2==i and y2==j:
				id_player=num
			
			if x==i and y==j:
				id_enemy=num
			
			num+=1
	
	for i in range(FIRST_ID,LAST_ID): #connect the graph
		#  º (i-18)  º  º
		#   /
		# (i)- (i+1)  º  º -->
		#  |   \
		# (i+19) (i+20)  º  º
		if i%LAST_COLUMN>0:
			astar.connect_points(i,i+RIGHT_ID,true)#right		
# warning-ignore:integer_division
		if i/TOTAL_COLUMNS<LAST_ROW_MINUS_TWO:
			astar.connect_points(i,i+BOTTOM_ID,true)#bottom
# warning-ignore:integer_division
		if i%LAST_COLUMN>0 and i/TOTAL_COLUMNS<LAST_ROW_MINUS_TWO:
			astar.connect_points(i,i+BOTTOM_RIGHT_ID,true)#bottom_right
# warning-ignore:integer_division
		if i%LAST_COLUMN>0 and i/TOTAL_COLUMNS>FIRST_ROW_PLUS_ONE:
			astar.connect_points(i,i+UP_RIGHT_ID,true)#up_right
func get_astar_path(): 
	if id_enemy!=null and id_player!=null:
		return astar.get_id_path(id_enemy, id_player)
	return null
	
