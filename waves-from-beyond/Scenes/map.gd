extends Node3D


func _on_radio_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		$Player.current = false
		$Room/Radio/Camera3D.current = true
	pass
