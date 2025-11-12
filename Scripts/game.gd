extends Node3D

@export var transition_duration: float = 1.0

@onready var newspaper = $Escenario/NewsPaper
@onready var view_newspaper = $Escenario/NewsPaper2.global_transform
@onready var normal_newspaper = $Escenario/NewsPaper.global_transform
@onready var pc_area = $Escenario/Pc/Screen/Area3D
@onready var player: Camera3D = $Player
@onready var phone = $Escenario/Phone/auricular
@onready var view_phone = $Player/auricular

@onready var phone_position = $Escenario/Phone/auricular.global_transform

var actual_camera: Camera3D
var next_camera: Camera3D
var is_moving = false
var is_zoomed = false
var newspaper_zoom = false

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

var cont = 0


func _ready() -> void:
	player.current = true
	actual_camera = player
	emit_signal("disble_colisions")


func _process(_delta: float) -> void:
	if !player.current:
		if Input.get_mouse_button_mask() == 2 and !is_moving:  # Clic derecho
			switch_to_camera_smooth(actual_camera, player)
			is_zoomed = false
	elif newspaper_zoom:
		if Input.get_mouse_button_mask() == 2 and !is_moving:
			newspaper_manager()
			


func switch_to_camera_smooth(from_camera: Camera3D, to_camera: Camera3D,tween1: Tween = null):
	from_camera.current = false
	is_moving = true
	# Crear cámara temporal para la transición
	var temp_camera = Camera3D.new()
	add_child(temp_camera)
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
	is_moving = false
	temp_camera.queue_free()
	emit_signal("disble_colisions")


func input_manager(camera:Camera3D, event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		is_zoomed = true
		actual_camera = camera
		await switch_to_camera_smooth(player, actual_camera)
		#pc_area.collision_layer = 1


func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Escenario/Radio/Camera3D, event)


func _on_map_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
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
	await input_manager($Escenario/Computer, event)


func _on_phone_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving :
		is_moving = true
		if !phone.visible:
			phone_manager()
		else:
			var tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.set_trans(Tween.TRANS_CIRC)
			tween.tween_property(phone, "global_transform",view_phone.global_transform, transition_duration)
			await tween.finished
			print(phone.visible)
			phone_manager()
			
		is_moving = false


func phone_manager():
	
	if !view_phone.visible:
		view_phone.visible = true
		phone.visible = false
	elif !phone.visible:
		view_phone.visible = false
		phone.visible = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(phone, "global_transform",phone_position, transition_duration)
		await tween.finished



func _on_news_paper_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
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
	print(event)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_LINEAR)
		is_zoomed = true
		actual_camera = $Escenario/Gato
		await switch_to_camera_smooth(player, actual_camera,tween)
