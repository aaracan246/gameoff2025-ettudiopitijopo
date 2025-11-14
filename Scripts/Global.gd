extends Node

var cont = 0
var dialogos = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
var sounds = ["evento1","evento2","evento3-1","evento3-2","evento3-3","evento3-4"]
func next_event():

	Dialogic.start(dialogos[cont])
	set_process_input(true)
	set_process_unhandled_input(true)
	cont+=1

func sounds_events():
	print(randi_range(0,sounds.size()))
	pass
	
