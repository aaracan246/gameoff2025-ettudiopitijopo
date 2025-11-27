extends Control

@onready var camera:Camera3D =$"../../../../OutDoor"
@onready var demo: Node3D = $"../../../.."

@onready var new_camera:Camera3D = $Camera/SubViewport/Camera3D
@onready var subviewport = $Camera/SubViewport
@onready var destktop = $Destktop
@onready var Outdoor_camera = $Camera
@onready var camera_button: Button = $Destktop/icons/camera/camera_btn
@onready var exit: Button = $Camera/exit
@onready var pause_menu: Control = $"../../../../UI/pause_menu"
@onready var pantalla: Control = $"."

# POPUPS
@onready var email_popup: ColorRect = $Destktop/popups/email_popup
@onready var file_popup: ColorRect = $Destktop/popups/file_popup
@onready var gallery_popup: ColorRect = $Destktop/popups/gallery_popup

@onready var book_popup: ColorRect = $Destktop/popups/book_popup
@onready var book_popup2: ColorRect = $Destktop/popups/book_popup2
@onready var book_popup3: ColorRect = $Destktop/popups/book_popup3
@onready var book_popup4: ColorRect = $Destktop/popups/book_popup4

@onready var trash_popup: ColorRect = $Destktop/popups/trash_popup
@onready var music_popup: Control = $Destktop/popups/music_popup

@onready var book: TextureRect = $Destktop/icons/book/book
@onready var email_alert: Sprite2D = $Destktop/icons/email/email_alert
const GLITCH = preload("uid://cyxw6yqjsc73o")

@export var texture_book : Resource = preload("res://Assets/pc/book.png")
@export var texture_ghost : Resource = preload("res://Assets/pc/book_glitch.png")
var popup_index = 0

var email_opened = false
var disable_start = false
signal start_events


func _ready() -> void:
	#camera = $"../../../../OutDoor"
	demo.camera_glitch.connect(_camera_glitch)
	Outdoor_camera.material.set_shader_parameter("glitch_intensity", 0.00)
	book.texture = texture_book
	new_camera.global_transform = camera.global_transform
	Dialogic.connect("signal_event", Callable(self, "_on_dialogic_signal"))

	#Global.screen_node = self
	await get_tree().create_timer(2).timeout
	email_alert_event()

func _on_dialogic_signal(argument):
	if argument == "pc":
		_on_book_btn_pressed() 


func unlock_calls():

	if book.texture == texture_ghost and email_opened and disable_start == false:
		disable_start = true
		emit_signal("start_events")

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
	email_opened = true
	unlock_calls()

	bring_to_front(email_popup)
	email_alert.visible = false

func _on_email_close_pressed() -> void:
	email_popup.visible = false

func _on_email_p_pressed() -> void:
	bring_to_front(email_popup)

func email_alert_event():
	AudioManager.pc_alert.play()
	email_alert.visible = true

# File
func _on_file_btn_pressed() -> void:
	bring_to_front(file_popup)

func _on_file_close_pressed() -> void:
	file_popup.visible = false

func _on_file_p_pressed() -> void:
	bring_to_front(file_popup)

# Book

func _on_book_btn_pressed() -> void:
	if book.texture == texture_book:
		glitch()
		
	else:
		unlock_calls()
		book_popup.visible = 1
		book_popup2.visible = 1
		book_popup3.visible = 1
		book_popup4.visible = 1
		#Disable shader
		book.material = null

func _camera_glitch():
	if !Outdoor_camera.visible:
		_on_camera_btn_pressed()
		
	var small = camera.get_node("small")
	var medium = camera.get_node("medium")
	var big = camera.get_node("big")
	var medium2 = $"../../../Killers/medium2"
	Global.reproduce_sound("killer","steps")
	await get_tree().create_timer(2).timeout
	await transition_killer(small)
	await transition_killer(medium)
	await transition_killer(big)
	Outdoor_camera.material.set_shader_parameter("glitch_intensity", 10.0)
	AudioManager.glitch_killer.play()
	await get_tree().create_timer(1).timeout
	Outdoor_camera.material.set_shader_parameter("glitch_intensity", 0.0)
	medium2.visible = true


func transition_killer(node:Node):
	Outdoor_camera.material.set_shader_parameter("glitch_intensity",7.77)
	AudioManager.glitch_killer.play()
	await get_tree().create_timer(1).timeout
	Outdoor_camera.material.set_shader_parameter("glitch_intensity", 0.0)
	node.visible = true
	await get_tree().create_timer(1).timeout
	node.visible = false


func glitch():
	# Book Glitch
	await get_tree().create_timer(0.5).timeout
	AudioManager.book_glitch.play()
	var mat = ShaderMaterial.new()
	mat.shader = GLITCH
	book.material = mat
	await get_tree().create_timer(2).timeout
	
	# Se abre todas las pestañas
	bring_to_front(file_popup)
	AudioManager.windows_error.play()
	await get_tree().create_timer(0.1).timeout
	bring_to_front(email_popup)
	AudioManager.windows_error.play()
	
	await get_tree().create_timer(0.1).timeout
	book_popup.visible = 1
	AudioManager.windows_error.play()
	await get_tree().create_timer(0.1).timeout
	bring_to_front(gallery_popup)
	AudioManager.windows_error.play()
	
	await get_tree().create_timer(0.1).timeout
	bring_to_front(trash_popup)
	AudioManager.windows_error.play()
	
	#book.visible = false
	#book_ghost.visible = true
	book.texture = texture_ghost
	AudioManager.ghost_1.play()
	await get_tree().create_timer(1).timeout
	
	# Se cierran
	trash_popup.visible = false
	await get_tree().create_timer(0.2).timeout
	gallery_popup.visible = false
	await get_tree().create_timer(0.2).timeout
	email_popup.visible = false
	await get_tree().create_timer(0.2).timeout
	file_popup.visible = false
	await get_tree().create_timer(0.2).timeout
	book_popup.visible = false
	book_popup2.visible = false
	book_popup3.visible = false
	book_popup4.visible = false

func _on_book_close_pressed() -> void:
	book_popup.visible = false
	book_popup2.visible = false
	book_popup3.visible = false
	book_popup4.visible = false

func _on_book_p_pressed() -> void:
	bring_to_front(book_popup)
	bring_to_front(book_popup2)
	bring_to_front(book_popup3)
	bring_to_front(book_popup4)

func book_glitch_event():
	AudioManager.pc_alert.play()
	email_alert.visible = true

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
