extends Camera3D

@export var suavizado: float = 10.0
@export var rotations := {
	"front": Vector3(0.0, deg_to_rad(0.0), 0.0),
	"right": Vector3(0.0, deg_to_rad(-90.0), 0.0),
	"back": Vector3(0.0, deg_to_rad(180.0), 0.0),
	"left": Vector3(0.0, deg_to_rad(90.0), 0.0),
}
var list_rotations = ["front","right","back","left"]
var objetivo_rot: Vector3
var rot_actual: Vector3
var rotacion = "front"
var positionXYZ = 0
var timer_rotation = false

signal down

func _ready():
	rot_actual = rotation
	objetivo_rot = rotations[rotacion]
	$".".set_keep_aspect_mode(KEEP_WIDTH)


func _process(delta: float) -> void:
	# Interpola suavemente los tres ejes de rotación
	rot_actual.x = lerp_angle(rot_actual.x, objetivo_rot.x, suavizado * delta)
	rot_actual.y = lerp_angle(rot_actual.y, objetivo_rot.y, suavizado * delta)
	rotation = rot_actual
 

	#AudioManager.chair_swing.play()

func rotation_manager():
	if timer_rotation == false:
		emit_signal("down")
		rotacion = list_rotations[positionXYZ]
		objetivo_rot = rotations[rotacion]
		$rotationTimer.start(0.5)
		timer_rotation = true



func _on_right_mouse_entered() -> void:
	if !timer_rotation : 
		if positionXYZ < 3:
			positionXYZ += 1
			
		else: 
			positionXYZ = 0
		rotation_manager()

func _on_left_mouse_entered() -> void:
	if !timer_rotation : 
		if positionXYZ > 0:
			positionXYZ -= 1
		elif positionXYZ == 0:
			positionXYZ = 3
		else: 
			positionXYZ = 0
		rotation_manager()


func _on_rotation_timer_timeout() -> void:
	timer_rotation = false
