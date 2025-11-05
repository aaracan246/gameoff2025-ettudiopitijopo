extends Node3D


func _on_radio_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		$Player.current = false
		$Room/Radio/Camera3D.current = true
	pass
