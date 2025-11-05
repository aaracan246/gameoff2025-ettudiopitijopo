extends Camera3D

@export var suavizado: float = 10.0

var objetivo_rot: Vector3
var rot_actual: Vector3
var positionXYZ = 0

@export var rotations := {
	"front": Vector3(0.0, deg_to_rad(0.0), 0.0),
	"right": Vector3(0.0, deg_to_rad(-90.0), 0.0),
	"back": Vector3(0.0, deg_to_rad(180.0), 0.0),
	"left": Vector3(0.0, deg_to_rad(90.0), 0.0),
}

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


func _on_right_mouse_entered() -> void:
	print("Rotar a la derecha")
	if positionXYZ < 3:
		positionXYZ += 1
		
	else: 
		positionXYZ = 0
	rotation_manager()

func _on_left_mouse_entered() -> void:
	print("Rotar a la izquierda")
	if positionXYZ > 0:
		positionXYZ -= 1
	elif positionXYZ == 0:
		positionXYZ = 3
	else: 
		positionXYZ = 0

	rotation_manager()
