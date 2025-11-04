extends Camera3D

@export var sensibilidad_mouse: float = 0.001
@export var limite_vertical: float = 1.5  # ~85 grados

var rotacion_vertical: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Rotación horizontal (eje Y)
		rotate_y(-event.relative.x * sensibilidad_mouse)
		
		# Rotación vertical (eje X)
		rotacion_vertical += event.relative.y * sensibilidad_mouse
		rotacion_vertical = clamp(rotacion_vertical, -limite_vertical, limite_vertical)
		
		# Aplicar rotación vertical
		rotation.x = rotacion_vertical

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_mouse_capture()

func toggle_mouse_capture():
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
