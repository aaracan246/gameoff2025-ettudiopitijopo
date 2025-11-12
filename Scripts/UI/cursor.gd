extends Sprite2D

@export var texture_idle : Resource
@export var texture_pointing : Resource
@export var texture_click : Resource
@export var texture_pc : Resource
@onready var cursor: Sprite2D = $"."


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	process_mode =Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), 16.5*delta)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		cursor.texture = texture_click
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		cursor.texture = texture_pointing
	else:
		cursor.texture = texture_idle
