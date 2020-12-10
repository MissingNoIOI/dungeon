extends AudioStreamPlayer
var sounds=[]

func _ready():
	randomize()
	sounds.append(preload("res://resource/audio/Background/Intense.ogg"))
	sounds.append(preload("res://resource/audio/Background/Lonely Witch.ogg"))
	sounds.append(preload("res://resource/audio/Background/Menu Music.ogg"))
	sounds.append(preload("res://resource/audio/Background/Rising.ogg"))
	stream=sounds.front()

func play_random() -> void:
	sounds.shuffle()
	stream=sounds.front()
	stream.set_loop(true)
	play()

