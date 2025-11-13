extends Control

var camera:Camera3D
@onready var new_camera:Camera3D = $Camera/SubViewport/Camera3D
@onready var subviewport = $Camera/SubViewport
@onready var destktop = $Destktop
@onready var Outdoor_camera = $Camera
@onready var camera_button: Button = $camera/camera_btn
@onready var exit: Button = $Camera/exit
@onready var pause_menu: Control = $"../../../../UI/pause_menu"

# POPUPS
@onready var book_popup: Sprite2D = $Destktop/book_popup
@onready var email_popup: Sprite2D = $Destktop/email_popup
@onready var file_popup: Sprite2D = $Destktop/file_popup



func _ready() -> void:
	camera = get_tree().get_root().get_node("Demo/OutDoor")
	new_camera.global_transform = camera.global_transform


func _on_exit_pressed() -> void:
	destktop.visible = true
	Outdoor_camera.visible = false

func _on_camera_btn_pressed() -> void:
	destktop.visible = false
	Outdoor_camera.visible = true


func _on_settings_btn_pressed() -> void:
	pause_menu.visible = true
	pause_menu.pause_game()
	



func _on_email_btn_pressed() -> void:
	email_popup.visible = true

func _on_email_close_pressed() -> void:
	email_popup.visible = false



func _on_file_btn_pressed() -> void:
	file_popup.visible = true

func _on_file_close_pressed() -> void:
	file_popup.visible = false
	
	


func _on_book_btn_pressed() -> void:
	book_popup.visible = true


func _on_book_close_pressed() -> void:
	book_popup.visible = false
