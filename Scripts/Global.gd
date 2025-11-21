extends Node

var timer_duration = 1.0
var screen_node: Node = null
var cont = 0
var dialogos = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
var sounds = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
var vhs_enabled := true
var sounds_map = {}


func _ready() -> void:
	await get_tree().create_timer(10).timeout

func next_event():
	Dialogic.start(dialogos[cont])
	cont+=1

func sounds_events():
	print(randi_range(0,sounds.size()))
	if randi_range(0,sounds.size()) == 2:
		pass
	pass
	
func update_sounds(soundss: Dictionary):
	sounds_map = soundss
	
	pass
