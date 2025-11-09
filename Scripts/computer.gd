extends StaticBody3D
@onready var screen: MeshInstance3D = $Screen
@onready var sub_viewport: SubViewport = $Screen/SubViewport
@onready var area_3d: Area3D = $Screen/Area3D
@onready var pantalla: Control = $Screen/SubViewport/pantalla

var mouse_inside = false
var selected = false
func _ready() -> void:
	#area_3d.mouse_entered.connect()
	input_event.connect(_on_input_event)
	
func _on_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int):
	var mouse3D = screen.global_transform.affine_inverse() * event_position
	var calculate2DPosition = Vector2(mouse3D.x,mouse3D.z)
	
	var screenSize = screen.mesh.size
	calculate2DPosition += screenSize / 2
	calculate2DPosition /= screenSize
	
	var mouse2D = calculate2DPosition * Vector2(pantalla.size)
	
	event.position = mouse2D
	
	sub_viewport.push_input(event)
	
func set_select(boolean: bool):
	selected = boolean
	
	if boolean:
		Input.mouse_mode = Input. MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_mouse_input_event(_camera: Node, event: InputEvent, event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	var mouse3D = screen.global_transform.affine_inverse() * event_position
	var calculate2DPosition = Vector2(mouse3D.x,mouse3D.z)
	
	var screenSize = screen.mesh.size
	calculate2DPosition += screenSize / 2
	calculate2DPosition /= screenSize
	
	var mouse2D = calculate2DPosition * Vector2(sub_viewport.size)
	
	event.position = mouse2D
	
	sub_viewport.push_input(event)


func _on_mouse_entered() -> void:
	mouse_inside = true


func _on_mouse_exited() -> void:
	mouse_inside = false
