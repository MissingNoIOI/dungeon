extends "CharacterScript.gd"

var _new_PCStats := preload("res://library/PCStats.gd").new()

var die:bool

var has_key:=false

var initial_dr
var initial_ar

var special:String="nothing"

func _init():
	
#warning-ignore:integer_division
	ar=_new_PCStats.STRENGTH*4
	dr=_new_PCStats.DEXTERITY/4
	
	initial_dr=dr #for change armor
	initial_ar=ar #for change weapon
	
	hp=_new_PCStats.HP
	die=false
