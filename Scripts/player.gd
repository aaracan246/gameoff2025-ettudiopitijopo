extends Camera3D

@export var suavizado: float = 10.0
@export var rotations := {
	"front": Vector3(0.0, deg_to_rad(0.0), 0.0),
	"right": Vector3(0.0, deg_to_rad(-90.0), 0.0),
	"back": Vector3(0.0, deg_to_rad(180.0), 0.0),
	"left": Vector3(0.0, deg_to_rad(90.0), 0.0),
}
var list_rotations = ["front","right","back","left"]
var left_timer = false
var right_timer = false
var objetivo_rot: Vector3
var rot_actual: Vector3
var rotacion = "front"
var positionXYZ = 0
var timer_rotation = false

func _ready():
	rot_actual = rotation
	objetivo_rot = rotations[rotacion]
	

func _process(delta: float) -> void:
	# Interpola suavemente los tres ejes de rotación
	rot_actual.x = lerp_angle(rot_actual.x, objetivo_rot.x, suavizado * delta)
	rot_actual.y = lerp_angle(rot_actual.y, objetivo_rot.y, suavizado * delta)
	rotation = rot_actual
 


func rotation_manager(direcction:String):
	rotacion = list_rotations[positionXYZ]
	if direcction == "right":
		match rotacion:
			"front":
				objetivo_rot = rotations["right"]
			"right":
				objetivo_rot = rotations["back"]
			"back":
				objetivo_rot = rotations["left"]
			"left":
				objetivo_rot = rotations["front"]
	elif direcction == "left":
		match rotacion:
			"front":
				objetivo_rot = rotations["left"]
			"right":
				objetivo_rot = rotations["front"]
			"back":
				objetivo_rot = rotations["right"]
			"left":
				objetivo_rot = rotations["back"]

	$rotationTimer.start()
	timer_rotation = true


func _on_right_mouse_entered() -> void:
	print(positionXYZ)
	if !timer_rotation : 
		if positionXYZ < 3:
			positionXYZ += 1
			
		else: 
			positionXYZ = 0
		
	rotation_manager("right")

func _on_left_mouse_entered() -> void:
	print(positionXYZ)
	if !timer_rotation : 
		if positionXYZ > 0:
			positionXYZ -= 1
		elif positionXYZ == 0:
			positionXYZ = 3
		else: 
			positionXYZ = 0

	rotation_manager("left")

func _on_left_mouse_exited() -> void:
	left_timer = false


func _on_right_mouse_exited() -> void:
	right_timer = false


func _on_timer_right_timeout() -> void:
	right_timer = true


func _on_timer_left_timeout() -> void:
	left_timer = true


func _on_rotation_timer_timeout() -> void:
	timer_rotation = false
