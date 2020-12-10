extends VBoxContainer


const _new_GroupName = preload("res://library/GroupName.gd")

var _turn_counter: int = 0
var _turn_text: String = "Turn: {0}"
var _HP_text: String = "HP: {0}"


onready var _label_help: Label = get_node("Help")
onready var _label_turn: Label = get_node("Turn")
onready var _label_HP: Label = get_node("HP")
onready var _label_key: Label = get_node("Key")


func _ready() -> void:
	_label_help.text = "Dungeon"
	_update_turn()


func _on_Schedule_turn_started(current_sprite: Sprite) -> void:
	if current_sprite.is_in_group(_new_GroupName.PC):
		_turn_counter += 1
		_update_turn()
		_update_HP(current_sprite.hp)
		_update_key(current_sprite)

func _update_key(pc):
	if pc.has_key:
		_label_key.text="Key = yes"
	else:
		_label_key.text="Key = no"

func _update_turn() -> void:
	_label_turn.text = _turn_text.format([_turn_counter])	

func _update_HP(my_hp:int) -> void:
	_label_HP.text = _HP_text.format([my_hp])

func _on_SaveLoadManager_load_game(_message: String,hp:int,turn:int) -> void:
	_update_HP(hp)
	_turn_counter = turn
	_update_turn()

func _on_PCMove_restart(_message: String,hp:int,turn:int) -> void:
	_update_HP(hp)
	_turn_counter = turn
	_update_turn()
