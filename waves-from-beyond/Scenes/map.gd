extends Node3D


func _process(_delta: float) -> void:
	if !$Player.current:
		if Input.get_mouse_button_mask() == 2:
			$Player.current = true
	
	pass

func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:

		$Player.current = false
		$Room/Radio/Camera3D.current = true
	pass
