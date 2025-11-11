extends StaticBody3D

@onready var ruleta: StaticBody3D = $ruleta


func _on_ruleta_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	#print(event)
	if  event.button_mask == MOUSE_BUTTON_LEFT:
		if event is InputEventMouseMotion:
			motion_manager(event.velocity)


func motion_manager(velocity: Vector2):
	var rotacion = velocity.angle() *0.1
	ruleta.rotate_z(rotacion)
	
