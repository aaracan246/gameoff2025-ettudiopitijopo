extends Node

var timer_duration = 1.0
var screen_node: Node = null
var cont = 0
var dialogos = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
var sounds = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]


func _ready() -> void:
	await get_tree().create_timer(10).timeout
	#screen_node.email_alert_event()
	
	

func next_event():
	Dialogic.start(dialogos[cont])
	set_process_input(true)
	set_process_unhandled_input(true)
	print(Dialogic.Inputs.is_input_blocked())
	
	cont+=1

func sounds_events():
	print(randi_range(0,sounds.size()))
	pass
	
