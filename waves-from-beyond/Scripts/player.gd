extends Camera3D

@export var suavizado: float = 10.0
@export_range(0, 1000) var min_zoom: float = 10
@export_range(0, 1000) var max_zoom: float = 20
@export_range(0, 1000, 0.1) var zoom_speed: float = 50
@export var rotations := {
	"front": Vector3(0.0, deg_to_rad(0.0), 0.0),
	"right": Vector3(0.0, deg_to_rad(-90.0), 0.0),
	"back": Vector3(0.0, deg_to_rad(180.0), 0.0),
	"left": Vector3(0.0, deg_to_rad(90.0), 0.0),
}


var objetivo_rot: Vector3
var rot_actual: Vector3
var positionXYZ = 0
var zoom_level = 64.0

func _ready():
	rot_actual = rotation
	objetivo_rot = rotation

func _process(delta: float) -> void:
	# Interpola suavemente los tres ejes de rotación
	rot_actual.x = lerp_angle(rot_actual.x, objetivo_rot.x, suavizado * delta)
	rot_actual.y = lerp_angle(rot_actual.y, objetivo_rot.y, suavizado * delta)
	rotation = rot_actual
 


func rotation_manager():
	match positionXYZ:
		0:
			objetivo_rot = rotations["front"]
		1:
			objetivo_rot = rotations["right"]
		2:
			objetivo_rot = rotations["back"]
		3:
			objetivo_rot = rotations["left"]

func zoom_manager():
	zoom_level = clamp(zoom_level, min_zoom, max_zoom)
	position.x = lerp(position.x, zoom_level, 0.1)

func _on_right_mouse_entered() -> void:
	if positionXYZ < 3:
		positionXYZ += 1
		
	else: 
		positionXYZ = 0
	rotation_manager()

func _on_left_mouse_entered() -> void:
	if positionXYZ > 0:
		positionXYZ -= 1
	elif positionXYZ == 0:
		positionXYZ = 3
	else: 
		positionXYZ = 0

	rotation_manager()


func _on_radio_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_mask == 1:
		zoom_manager()
