extends Sprite2D

@export var texture_idle : Resource
@export var texture_pointing : Resource
@export var texture_click : Resource
@export var texture_pc : Resource
@onready var cursor: Sprite2D = $"."

var interactive = false
var pc = false
var click_scale := Vector2(0.5, 0.5)  
var normal_scale := Vector2(1, 1)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	process_mode =Node.PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), 16.5*delta)
	
	if pc:
		cursor.texture = texture_pc

		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			scale = lerp(scale, click_scale, 20 * delta)
		else:
			scale = lerp(scale, normal_scale, 12 * delta)
	else:
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			cursor.texture = texture_click
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			cursor.texture = texture_pointing
		elif interactive:
			cursor.texture = texture_pointing
		else:
			cursor.texture = texture_idle
	interactive = false
	print(cursor.texture.resource_path)


func _on_child_entered_tree(node: Node) -> void:
	print(node)


func _on_demo_interactive_object() -> void:
	interactive = true
	cursor.texture = texture_pointing


func _on_pc_pc_mouse(inside: bool) -> void:
	pc = inside
