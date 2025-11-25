extends Node3D

@export var transition_duration: float = 1.0

@onready var newspaper = $Escenario/NewsPaper
@onready var view_newspaper = $Escenario/NewsPaper2.global_transform
@onready var normal_newspaper = $Escenario/NewsPaper.global_transform
@onready var pc_area = $Escenario/Pc/Screen/Area3D
@onready var player: Camera3D = $Player
@onready var phone = $Escenario/Phone/auricular
@onready var view_phone = $Player/auricular
@onready var map: StaticBody3D = $Escenario/Map
@onready var radio: StaticBody3D = $Escenario/Radio
@onready var pc: StaticBody3D = $Escenario/Pc
@onready var phone_station: StaticBody3D = $Escenario/Phone
@onready var lampara: StaticBody3D = $Escenario/lampara
@onready var cat: StaticBody3D = $Escenario/cat
@onready var puerta: StaticBody3D = $Escenario/puerta

@onready var temp_camera = $deault_camera

@onready var phone_position = $Escenario/Phone/auricular.global_transform
@onready var screen = $Escenario/Pc/SubViewport/pantalla

var normal_door :Transform3D

var actual_camera: Camera3D
var next_camera: Camera3D
var is_moving = false
var is_zoomed = false
var newspaper_zoom = false
var interactive = true
var door_open = false
var calling = true

@export var size_shader = 1.02
@export var color_shader =  Color(1.0, 1.0, 0.0, 0.62)
@export var timer_duration = 15.0

signal entrada
signal merendero1
signal parking
signal merendero2
signal obras
signal embarcadero
signal cafe
signal mirador
signal descanso
signal rescate

signal disble_colisions

@warning_ignore("unused_signal")
signal colgar

signal interactive_object
var cont = 0
@onready var sounds_map = {
	"phone": {"ring" :phone_station.get_node("ring"),"down":phone_station.get_node("down"),"pickup":phone_station.get_node("pickup"),"beep":phone_station.get_node("beep") },
	"cat": {"hiss":cat.get_node("hiss"),"meow":cat.get_node("meow"),"purr":cat.get_node("purr"),"shake":cat.get_node("shake")},
	"puerta": {"open/close":puerta.get_node("close_open")},
	"random":[cat.get_node("hiss"),cat.get_node("meow"),cat.get_node("purr"),cat.get_node("shake"),puerta.get_node("close_open")],
	
}

@onready var sounds_list =[
	cat.get_node("hiss"),cat.get_node("meow"),cat.get_node("purr"),cat.get_node("shake"),
]

signal change_video(string:String)


func _ready() -> void:
	normal_door = puerta.global_transform
	for node in [map, radio, pc, phone_station, lampara, cat, newspaper, puerta]:
		node.mouse_entered.connect(_mouse_entered_area.bind(node))
		node.mouse_exited.connect(_mouse_exited_area.bind(node))
		var outline_material = get_shader(node)
		if outline_material:
			outline_material.set_shader_parameter("size", 0.00)
			outline_material.set_shader_parameter("color",color_shader)
	player.current = true
	actual_camera = player
	Dialogic.connect("signal_event", Callable(self, "_on_dialogic_signal"))
	screen.connect("start_events", Callable(self, "_start_events"))
	emit_signal("disble_colisions")
	Dialogic.timeline_started.connect(set_physics_process.bind(true))
	Dialogic.timeline_started.connect(set_process_input.bind(true))
	
	Global.update_sounds(sounds_map)
	Global.random_sound()
	


func _process(_delta: float) -> void:
	if !player.current:
		if Input.get_mouse_button_mask() == 2 and !is_moving:  # Clic derecho
			switch_to_camera_smooth(actual_camera, player)
			is_zoomed = false
	elif newspaper_zoom:
		if Input.get_mouse_button_mask() == 2 and !is_moving:
			newspaper_manager()



func _on_dialogic_signal(argument):	
	if argument == "colgar":
		colgar_phone()
	if argument == "mapa":
		switch_to_camera_smooth(actual_camera,$Escenario/Mapa)
	if argument == "pc":
		switch_to_camera_smooth(actual_camera,$Escenario/Computer)
	if argument == "radio":
		switch_to_camera_smooth(actual_camera,$Escenario/Radio/Camera3D)
	else:
		emit_signal("change_video",argument)


func _start_events() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.start(5)
	await  timer.timeout
	timer.queue_free()
	incoming_call()


func incoming_call():
	phone_station.get_node("ring").play()
	Global.reproduce_sound("phone","ring")
	calling = true


func colgar_phone():
	if calling:
		calling = false
		phone_manager()
		var timer = Timer.new()
		add_child(timer)
		timer.autostart = true
		timer.start(timer_duration)
		timer.wait_time = timer_duration
		await  timer.timeout
		Global.random_sound()
		timer.start(timer_duration)
		await  timer.timeout
		timer.queue_free()
		
		incoming_call()

func get_shader(node):
	var shader = node.get_node("mesh")
	if node == cat:
		shader = node.get_node("Gato").get_node("metarig/Skeleton3D/Cylinder")
	if shader:
		if node == lampara or node == cat:
				
			shader = shader.get_active_material(0)
		else:
			shader = shader.get_surface_override_material(0)
			#EL GATO AL ALÑADIRLE EL SHADER NO LO DETECTA
		return shader.next_pass

func shader_manager(node):
	var outline_material = get_shader(node)
	if outline_material:
		if interactive and !is_zoomed:
			
			outline_material.set_shader_parameter("size", 1.02)
		else :
			outline_material.set_shader_parameter("size", 0.0)


func _mouse_entered_area(node):
	interactive = true
	shader_manager(node)
	emit_signal("interactive_object",interactive)

func _mouse_exited_area(node):
	interactive = false
	shader_manager(node)
	emit_signal("interactive_object",interactive)
	
	
func switch_to_camera_smooth(from_camera: Camera3D, to_camera: Camera3D,tween1: Tween = null):
	from_camera.current = false
	is_moving = true
	# Crear cámara temporal para la transición
	temp_camera.global_transform = from_camera.global_transform
	temp_camera.current = true
	if tween1:
		tween1.tween_property(temp_camera, "global_transform", to_camera.global_transform, transition_duration)
		await tween1.finished
	else:
		# Animación suave con Tween
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(temp_camera, "global_transform", to_camera.global_transform, transition_duration)
	
	# Esperar a que termine la animación
		await tween.finished
	# Activar cámara final y limpiar
	to_camera.current = true
	actual_camera = to_camera
	is_moving = false
	emit_signal("disble_colisions")

func input_manager(camera:Camera3D, event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		is_zoomed = true
		
		actual_camera = camera
		await switch_to_camera_smooth(player, actual_camera)

func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_zoomed:
		shader_manager(radio)
	input_manager($Escenario/Radio/Camera3D, event)

func _on_map_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_zoomed:
		shader_manager(map)
	if event is InputEventMouseButton and event.pressed and not is_zoomed:
		AudioManager.chair_roll.play()
	input_manager($Escenario/Mapa, event)


			
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		cont = randi_range(0,9)
		match cont:
			0:
				emit_signal("entrada")
			1:
				emit_signal("cafe")
			2:
				emit_signal("descanso")
			3:
				emit_signal("embarcadero")
			4:
				emit_signal("merendero1")
			5:
				emit_signal("merendero2")
			6:
				emit_signal("mirador")
			7:
				emit_signal("obras")
			8:
				emit_signal("parking")
			9:
				emit_signal("rescate")

func _on_pc_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_zoomed:
		shader_manager(pc)

	await input_manager($Escenario/Computer, event)



func _on_phone_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_zoomed:
		shader_manager(phone)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving :
		is_moving = true

		if !phone.visible:
			phone_manager()
		else:
			
			AudioManager.phone_pickup.play()
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_CIRC)
			tween.tween_property(phone, "global_transform",view_phone.global_transform, transition_duration)
			await tween.finished
			phone_manager()
			
		is_moving = false



func phone_manager():
	if calling == true:
		Global.stop_sound("phone","ring")
		Global.reproduce_sound("phone","pickup")
		Global.next_event()
		view_phone.visible = true
		phone.visible = false
	elif !view_phone.visible and !calling:
		Global.reproduce_sound("phone","pickup")
		Global.reproduce_sound("phone","beep")
		view_phone.visible = true
		phone.visible = false
	elif !phone.visible:
		view_phone.visible = false
		phone.visible = true
		Global.stop_sound("phone","beep")
		Global.reproduce_sound("phone","down")
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(phone, "global_transform",phone_position, transition_duration)
		await tween.finished



func _on_news_paper_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_zoomed:
		shader_manager(newspaper)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		is_zoomed = true
		
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(newspaper, "global_transform", view_newspaper, transition_duration)
		AudioManager.newspaper_pickup.play()
		newspaper_zoom = true


func newspaper_manager():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(newspaper, "global_transform", normal_newspaper, transition_duration)
	AudioManager.newspaper_drop.play()
	newspaper_zoom = false
	is_zoomed = false
	


func _on_cat_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if is_zoomed:
		shader_manager(cat)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		sounds_map["cat"]["meow"].play()
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		is_zoomed = true
		actual_camera = $Escenario/Gato
		await switch_to_camera_smooth(player, actual_camera,tween)


func _on_lampara_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		var onOff = $Escenario/lampara/SpotLight3D.visible
		$Escenario/lampara/SpotLight3D.visible = !onOff
		(AudioManager.lamp_on if onOff else AudioManager.lamp_off).play()




func _on_player_move() -> void:
	if newspaper_zoom:
		newspaper_manager()


func _on_puerta_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		door_manager()



func door_manager():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	Global.reproduce_sound("puerta","open/close")
	if !door_open:
		#ABRIR
		tween.tween_property(puerta, "global_transform",$Escenario/puerta2.global_transform, transition_duration * 3 )
		door_open = true
	else:
		#CERRAR
		tween.tween_property(puerta, "global_transform",normal_door, transition_duration * 3)
		door_open = false
		
