extends Control

var camera:Camera3D
@onready var new_camera:Camera3D = $Camera/SubViewport/Camera3D
@onready var subviewport = $Camera/SubViewport
@onready var destktop = $Destktop
@onready var Outdoor_camera = $Camera
@onready var camera_button: Button = $Destktop/camera
@onready var exit: Button = $Camera/exit


func _ready() -> void:
	camera = get_tree().get_root().get_node("Demo/Room/OutDoor")
	new_camera.global_transform = camera.global_transform
 

	
func _on_camera_pressed() -> void:
	destktop.visible = false
	Outdoor_camera.visible = true


func _on_exit_pressed() -> void:
	destktop.visible = true
	Outdoor_camera.visible = false


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			
			match event.global_position:
				camera_button.global_position:
					camera_button.emit_signal("pressed")
					print("PRESIONADOOOOOOOOOOOOOOOOOOOOOOOOOOO")


func _on_mouse_entered() -> void:
	var custom_cursor_image = load("res://icon.svg")
	Input.set_custom_mouse_cursor(custom_cursor_image) 


func _on_mouse_exited() -> void:
	var custom_cursor_image = load("res://cursor.png")
	Input.set_custom_mouse_cursor(custom_cursor_image) 
