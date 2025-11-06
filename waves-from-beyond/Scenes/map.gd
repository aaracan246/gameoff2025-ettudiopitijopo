extends Node3D

@export var transition_duration: float = 1.0

func _process(_delta: float) -> void:
	if !$Player.current:
		if Input.get_mouse_button_mask() == 2:  # Clic derecho
			switch_to_camera_smooth($Room/Radio/Camera3D, $Player)

func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		switch_to_camera_smooth($Player, $Room/Radio/Camera3D)

func switch_to_camera_smooth(from_camera: Camera3D, to_camera: Camera3D):
	from_camera.current = false
	
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
	temp_camera.queue_free()
