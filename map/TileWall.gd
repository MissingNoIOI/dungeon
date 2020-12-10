extends TileSet

var array_subtiles=[]#stores the collision subtiles loaded from tileset shapes

func _init():
	var shapes=self.tile_get_shapes(1)
	if shapes.size()>0:		
		for i in shapes:
			var subtile=i["autotile_coord"]					
			array_subtiles.append(subtile)

func is_in_array_subtiles(pos:Vector2)->bool:
	return array_subtiles.has(pos)	
