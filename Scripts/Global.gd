extends Node

var cont = 1
var timer_duration = 1.0
func next_event():
	var timer = Timer.new()
	add_child(timer)
	timer.autostart = true
	timer.start(timer_duration)
	timer.wait_time = timer_duration
	await  timer.timeout
	Dialogic.start("evento" + str(cont))
	set_process_input(true)
	set_process_unhandled_input(true)
	cont+=1
