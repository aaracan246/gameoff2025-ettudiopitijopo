extends Control

var camera:Camera3D
@onready var new_camera:Camera3D = $Camera/SubViewport/Camera3D
@onready var subviewport = $Camera/SubViewport
@onready var destktop = $Destktop
@onready var Outdoor_camera = $Camera
@onready var camera_button: Button = $camera/camera_btn
@onready var exit: Button = $Camera/exit
@onready var pause_menu: Control = $"../../../../UI/pause_menu"
@onready var pantalla: Control = $"."

# POPUPS
@onready var email_popup: ColorRect = $Destktop/popups/email_popup
@onready var file_popup: ColorRect = $Destktop/popups/file_popup
@onready var gallery_popup: ColorRect = $Destktop/popups/gallery_popup
@onready var book_popup: ColorRect = $Destktop/popups/book_popup
@onready var trash_popup: ColorRect = $Destktop/popups/trash_popup
@onready var music_popup: Control = $Destktop/popups/music_popup

var popup_index = 0

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
	
func bring_to_front(popup: ColorRect):
	popup_index += 1
	popup.z_index = popup_index
	popup.visible = true
	

# Email
func _on_email_btn_pressed() -> void:
	bring_to_front(email_popup)

func _on_email_close_pressed() -> void:
	email_popup.visible = false
	
func _on_email_p_pressed() -> void:
	bring_to_front(email_popup)


# File
func _on_file_btn_pressed() -> void:
	bring_to_front(file_popup)

func _on_file_close_pressed() -> void:
	file_popup.visible = false
	
func _on_file_p_pressed() -> void:
	bring_to_front(file_popup)


# Book
func _on_book_btn_pressed() -> void:
	bring_to_front(book_popup)

func _on_book_close_pressed() -> void:
	book_popup.visible = false

func _on_book_p_pressed() -> void:
	bring_to_front(book_popup)



# Gallery
func _on_gallery_btn_pressed() -> void:
	bring_to_front(gallery_popup)

func _on_gallery_close_pressed() -> void:
	gallery_popup.visible = false

func _on_gallery_p_pressed() -> void:
	bring_to_front(gallery_popup)


# TRASH_BIN
func _on_trash_btn_pressed() -> void:
	bring_to_front(trash_popup)

func _on_trash_p_pressed() -> void:
	bring_to_front(trash_popup)
	
func _on_trash_close_pressed() -> void:
	trash_popup.visible = false

func _on_music_file_pressed() -> void:
	music_popup.visible = true
	AudioManager.credits.play()

func _on_music_close_pressed() -> void:
	music_popup.visible = false
	AudioManager.credits.stop()

func _on_music_p_pressed() -> void:
	music_popup.visible = true
	

func _on_off_btn_pressed() -> void:
	pantalla.visible = false
