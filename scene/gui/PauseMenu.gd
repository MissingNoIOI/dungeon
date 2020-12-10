extends VBoxContainer



const SaveLoadManager := preload("res://scene/main/SaveLoadManager.gd")
var _ref_SaveLoadManager : SaveLoadManager

var index:int=1
var last_index:int=-1
var total:int

var is_paused:bool=false

# Called when the node enters the scene tree for the first time.
func _ready():
	#total=get_child_count()	
	total=3
	self.set_visible(false)

func active(num:int) ->void:
	var label=get_child(num) as Label
	label.set_text("#"+label.get_text())

func deactivate(num:int) ->void:
	var label=get_child(num) as Label
	label.set_text(label.get_text().substr(1,-1))

func update_menu()->void:
	deactivate(last_index)
	active(index)
	
func load_game(_pc)->void:
	_ref_SaveLoadManager.load_game(_pc)
	
func save_game(_pc)->void:
	_ref_SaveLoadManager.save_game(_pc)


func disable_resume() ->void:
	var label=get_child(1) as Label
	label.hide()

func enable_resume() ->void:
	var label=get_child(1) as Label
	label.show()

func is_hide_resume() ->bool:
	var label=get_child(1) as Label
	return !label.is_visible()
	
func _on_SaveLoadManager_load_game(_message: String,_hp:int,_turn:int) -> void:
	enable_resume()
