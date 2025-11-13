extends Control

var camera:Camera3D
@onready var new_camera:Camera3D = $Camera/SubViewport/Camera3D
@onready var subviewport = $Camera/SubViewport
@onready var destktop = $Destktop
@onready var Outdoor_camera = $Camera
@onready var camera_button: Button = $camera/camera_btn
@onready var exit: Button = $Camera/exit


func _ready() -> void:
	camera = get_tree().get_root().get_node("Demo/OutDoor")
	new_camera.global_transform = camera.global_transform
	


func _on_camera_pressed() -> void:
	
	destktop.visible = false
	Outdoor_camera.visible = true


func _on_exit_pressed() -> void:
	destktop.visible = true
	Outdoor_camera.visible = false
