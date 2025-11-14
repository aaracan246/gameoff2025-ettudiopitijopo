extends Node

var cont = 1
var timer_duration = 1.0
var screen_node: Node = null

func _ready() -> void:
	await get_tree().create_timer(10).timeout
	#screen_node.email_alert_event()
	
	#AudioManager.phone_ring.play()
	##evento1
	#AudioManager.phone_beep.play()
	#
	#await get_tree().create_timer(15).timeout
	
	
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
