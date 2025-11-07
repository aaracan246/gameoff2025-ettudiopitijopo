extends Node3D

@export var transition_duration: float = 1.0
var actual_camera: Camera3D
var is_moving = false

func _ready() -> void:
	$Player.current = true

func _process(_delta: float) -> void:
	if !$Player.current:
		if Input.get_mouse_button_mask() == 2 and !is_moving:  # Clic derecho
			switch_to_camera_smooth(actual_camera, $Player)


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

func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving:
		actual_camera = $Room/Radio/Camera3D
		switch_to_camera_smooth($Player, actual_camera)

func _on_map_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving:
		actual_camera = $Room/Mapa
		switch_to_camera_smooth($Player, actual_camera)


func _on_pc_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving:
		actual_camera = $Room/Computer
		switch_to_camera_smooth($Player,  actual_camera)


func _on_phone_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and !is_moving:
		actual_camera = $Room/telefono
		switch_to_camera_smooth($Player,  actual_camera)


func _on_news_paper_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	pass # Replace with function body.
