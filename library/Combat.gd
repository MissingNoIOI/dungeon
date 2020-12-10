var _new_GroupName := preload("res://library/GroupName.gd").new()

var _rng := RandomNumberGenerator.new()

func init():
	_rng.randomize()

func attack(attacker:Sprite,defender:Sprite)->bool:
	
	var dice_attack=roll(1,6)
	var dice_defense=roll(1,6)	
	var dice_damage=roll(1,2)
	
	#print("atck:",attacker.ar," def:",defender.dr)
	if dice_attack>dice_defense:	
		var damage=(attacker.ar*dice_damage)-defender.dr
		print("attacker hit ",damage)	
		if damage>0:	
			defender.hp-=damage
		return true
	return false
	#else:
	#	print("defender blocks the hit")

func special(attacker:Sprite,defender:Sprite)->bool:
	
	var dice_attack=roll(1,6)
	var dice_defense=roll(1,6)	
	var dice_damage=roll(1,6)
	
	#print("atck:",attacker.ar," def:",defender.dr)
	if dice_attack>dice_defense:	
		var damage=(attacker.ar*dice_damage)-defender.dr
		#print("attacker hit ",damage)		
		if damage>0:
			defender.hp-=damage
		return true
	return false



func roll(number:int ,type:int  )->int:           
	var acc=0
# warning-ignore:unused_variable
	for x in range(0,number):                    
		acc += _rng.randi_range(1,type)  		          
	return acc
				
