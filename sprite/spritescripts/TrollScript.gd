extends "EnemyScript.gd" 

class_name Troll

func drop_item(ref_InitWorld,x:int,y:int)->void:
	ref_InitWorld._create_sprite_key(x,y)

