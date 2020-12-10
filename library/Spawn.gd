class_name Spawn

class EnemySpawner:
	var t
	var _hp:int
	var _speed:int
	var _strength:int
	var _dexterity:int
	var _attack_message:String
	var _weakness:String
	
	func _init(type:PackedScene,hp:int,speed:int,strength:int,dexterity:int, attack_message:String, weakness:String):
		t=type
		_hp=hp
		_speed=speed
		_strength=strength
		_dexterity=dexterity
		_attack_message=attack_message
		_weakness=weakness
		
	func spawn_enemy()-> Enemy:
		var enemy:Enemy=t.instance()
		enemy.hp=_hp
		enemy.speed=_speed
		enemy.strength=_strength
		enemy.dexterity=_dexterity
		enemy.attack_message=_attack_message
		enemy.weakness=_weakness
		enemy.post_init()
		return enemy
		
				
class ItemSpawner:
	var t
		
	func _init(type:PackedScene):
		t=type
	
	func spawn_item()-> Item:
		return t.instance()
