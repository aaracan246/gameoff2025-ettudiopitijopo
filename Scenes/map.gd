extends Node3D

@export var transition_duration: float = 1.0
@onready var newspaper = $Room/NewsPaper
@onready var view_newspaper = $Room/NewsPaper2.global_transform
@onready var normal_newspaper = $Room/NewsPaper.global_transform


var actual_camera: Camera3D
var next_camera: Camera3D
var is_moving = false
var is_zoomed = false

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





func _ready() -> void:
	$Player.current = true
	actual_camera = $Player

func _process(_delta: float) -> void:
	if !$Player.current:
		if Input.get_mouse_button_mask() == 2 and !is_moving:  # Clic derecho
			switch_to_camera_smooth(actual_camera, $Player)
			is_zoomed = false


func switch_to_camera_smooth(from_camera: Camera3D, to_camera: Camera3D):
	from_camera.current = false
	is_moving = true
	# Crear cámara temporal para la transición
	var temp_camera = Camera3D.new()
	add_child(temp_camera)
	temp_camera.global_transform = from_camera.global_transform
	temp_camera.current = true
	
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

func input_manager(camera:Camera3D, event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		is_zoomed = true
		actual_camera = camera
		switch_to_camera_smooth($Player, actual_camera)

func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Room/Radio/Camera3D, event)


func _on_map_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Room/Mapa, event)
	emit_signal("entrada")
	emit_signal("cafe")
	emit_signal("descanso")
	emit_signal("embarcadero")
	emit_signal("merendero1")
	emit_signal("merendero2")
	emit_signal("mirador")
	emit_signal("obras")
	emit_signal("parking")
	emit_signal("rescate")
	


func _on_pc_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Room/Computer, event)


func _on_phone_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	input_manager($Room/telefono, event)


func _on_news_paper_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving and !is_zoomed:
		is_zoomed = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(newspaper, "global_transform", view_newspaper, transition_duration)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and !is_moving :
		is_zoomed = false
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(newspaper, "global_transform", normal_newspaper, transition_duration)
