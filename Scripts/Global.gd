extends Node

var timer_duration = 1.0
var screen_node: Node = null
var cont = 2
var dialogos = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
var sounds = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
var vhs_enabled := true
var sounds_map = {}
var dead_awela:bool
var dead_camper:bool
var game_over: int

func _ready() -> void:
	await get_tree().create_timer(10).timeout


func next_event():
	Dialogic.start(dialogos[cont])
	cont+=1

func random_sound():
	sounds_map["random"][randi_range(0,sounds_map["random"].size() -1) ].play()
	
func update_sounds(soundss: Dictionary):
	sounds_map = soundss

func reproduce_sound(object:String,sound:String = ""):
	sounds_map[object][sound].play()

func stop_sound(object:String, sound:String = ""):
	var audio_node = sounds_map[object][sound]

	if audio_node.playing:
		audio_node.stop()
