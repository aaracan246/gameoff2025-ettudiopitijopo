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
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var murders: StaticBody3D = $Escenario/murders
@onready var sofa: StaticBody3D = $Escenario/Sofa

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
var vidas = 2
@onready var lifes_ui: Control = $UI/lifes_UI
@onready var ui: CanvasLayer = $UI
@onready var win_ui: Control = $UI/win
@onready var fade_out_ui: ColorRect = $UI/fade_out

@export var size_shader = 1.02
@export var color_shader =  Color(1.0, 1.0, 0.0, 0.62)
@export var timer_duration = 15.0


signal disble_colisions

@warning_ignore("unused_signal")
signal colgar

signal interactive_object
var cont = 2
@onready var sounds_map = {
	"phone": {"ring" :phone_station.get_node("ring"),"down":phone_station.get_node("down"),"pickup":phone_station.get_node("pickup"),"beep":phone_station.get_node("beep") },
	"cat": {"hiss":cat.get_node("hiss"),"meow":cat.get_node("meow"),"purr":cat.get_node("purr"),"shake":cat.get_node("shake")},
	"puerta": {"open":puerta.get_node("open"),"close":puerta.get_node("close"),"forzar":puerta.get_node("forzar")},
	"random":[cat.get_node("hiss"),cat.get_node("meow"),cat.get_node("purr"),cat.get_node("shake")],
	
	
}

@onready var sounds_list =[
	cat.get_node("hiss"),cat.get_node("meow"),cat.get_node("purr"),cat.get_node("shake"),
]

signal change_video(string:String)


func _ready() -> void:
	normal_door = puerta.global_transform
	for node in [map, radio, pc, phone_station, lampara, cat, newspaper, puerta,murders,sofa]:
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
	
	Global.update_sounds(sounds_map)
	#Global.random_sound()
	
	#para probar
	#win()
	#await get_tree().create_timer(3).timeout
	#Global.game_over = 1
	#game_over()
	
	


func _process(_delta: float) -> void:
	if !player.current:
		if Input.get_mouse_button_mask() == 2 and !is_moving:  # Clic derecho
			switch_to_camera_smooth(actual_camera, player)
			is_zoomed = false
	elif newspaper_zoom:
		if Input.get_mouse_button_mask() == 2 and !is_moving:
			newspaper_manager()



func _on_dialogic_signal(argument):
	if argument == "fail":
		vidas -= 1
		
		if vidas == 1:
			lifes_ui.lost_1()
		elif vidas == 0:
			lifes_ui.lost_2()
			Global.game_over = 1 # Importante para saber que final es
			game_over()
			
	
	if argument == "win":
		win()
		
	if argument == "colgar":
		colgar_phone()
	elif argument == "mapa":
		switch_to_camera_smooth(actual_camera,$Escenario/Mapa)
	elif argument == "pc":
		switch_to_camera_smooth(actual_camera,$Escenario/Computer)
	elif argument == "radio":
		switch_to_camera_smooth(actual_camera,$Escenario/Radio/Camera3D)
	else:
		emit_signal("change_video",argument)

func game_over():
	fade_out_ui.visible = true # Esto bloquea toda interacción del ratón
	
	await get_tree().create_timer(3).timeout
	lifes_ui.visible = false
	
	ui.fade_in() # Efecto fundido negro
	
	# Sonido transición
	AudioManager.game_over.play()
	await get_tree().create_timer(3).timeout

	# Detener TODOS los audios del juego
	AudioManager.stop_all_players_in_bus("SFX")
	AudioManager.stop_all_players_in_bus("Music")
	
	get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")
	ui.fade_out()
	fade_out_ui.visible = false
	self.queue_free()
	

func win():
	await get_tree().create_timer(3).timeout
	
	# Sale del zoom si lo tiene
	switch_to_camera_smooth(actual_camera, player)
	is_zoomed = false
	await get_tree().create_timer(1).timeout
	
	# Se gira hacia la puerta
	fade_out_ui.visible = true
	player.positionXYZ = 2
	player.rotation_manager()
	await get_tree().create_timer(1.5).timeout
	
	# Animación de puerta abriéndose
	door_event()
	AudioManager.door_opening.play()
	
	# Empieza a sonar la musica de los creditos
	AudioManager.credits.play()
	
	# Se silencia el bus de los efectos
	await get_tree().create_timer(2).timeout
	var sfx = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_mute(sfx, true)
	
	# Fundido a negro
	fade_out_ui.visible = true
	ui.fade_in()
	lifes_ui.visible = false
	
	await get_tree().create_timer(5).timeout
	# Pantalla de Win
	get_tree().change_scene_to_file("res://Scenes/UI/win.tscn")
	
	ui.fade_out()
	fade_out_ui.visible = false
	self.queue_free()

func _start_events() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.start(5)
	await  timer.timeout
	timer.queue_free()
	incoming_call()


func incoming_call():
	phone_station.get_node("green").visible = true
	Global.reproduce_sound("phone","ring")
	calling = true


func colgar_phone():
	if calling:
		calling = false
		phone_manager()
		phone_station.get_node("green").visible = false

		var timer = Timer.new()
		add_child(timer)
		timer.autostart = true
		timer.start(timer_duration)
		timer.wait_time = timer_duration
		await  timer.timeout
		if cont == 2:
			door_event()
		else:
			cont +=1
			Global.random_sound()
		timer.start(timer_duration)
		await  timer.timeout
		if door_open:
			Global.game_over = 2  # Importante para saber que final es
			get_tree().change_scene_to_file("res://Scenes/UI/game_over.tscn")
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
		input_manager($Escenario/Mapa, event)
		AudioManager.chair_roll.play()
		if randf() < 0.4:
			#INSERTAR AUDIO !!!!!PELIGRO KILLER!!!!!!!!
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property($Escenario/Map/small, "global_position", $Escenario/Map/small2.global_position, 1)
			await tween.finished
			var tween2 = create_tween()
			tween2.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_CUBIC)
			tween2.tween_property($Escenario/Map/small, "global_position", $Escenario/Map/small3.global_position, 1)
	



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
		#sounds_map["cat"]["meow"].play()
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		is_zoomed = true
		actual_camera = $Escenario/Gato
		await switch_to_camera_smooth(player, actual_camera,tween)
	elif event is InputEventMouseMotion and event.button_mask == 1  :
		sounds_map["cat"]["purr"].play()


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
	#Global.reproduce_sound("puerta","open/close")he importado nuevo audio y lo he metio con el audiomanager
	if !door_open:
		#ABRIR
		Global.reproduce_sound("puerta","forzar")

	if door_open:
		#CERRAR
		Global.reproduce_sound("puerta","close")
		tween.tween_property(puerta, "global_transform",normal_door, transition_duration * 3)
		door_open = false
		
func door_event():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	Global.reproduce_sound("puerta","open")
	tween.tween_property(puerta, "global_transform",$Escenario/puerta2.global_transform, transition_duration * 3 )
	door_open = true

func _on_murders_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Escenario/murder, event)


func _on_sofa_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Escenario/Gato, event)
	if is_zoomed:
		var collision_cat = cat.get_node("CollisionShape3D")
		collision_cat.disabled = false
