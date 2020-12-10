extends "CharacterScript.gd"

class_name Enemy

var speed: int

var stamina:int =100
var alerted:bool=false

var strength
var dexterity

var attack_message

var weakness

func post_init():
#warning-ignore:integer_division
	ar=strength*4
	dr=dexterity/4
	

func set_stamina(sta:int)->void:
	stamina=sta
func get_stamina()->int:
	return stamina
func set_alerted(alt:bool)->void:
	alerted=alt
func is_alerted()->bool:
	return alerted

