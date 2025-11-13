extends ColorRect
@onready var btn_prev: Button = $btn_prev
@onready var btn_next: Button = $btn_next
@onready var image: TextureRect = $Image

var images: Array[Texture2D] = []
var current_index: int = 0

func _ready() -> void:
	# Carga las imágenes (pon las tuyas en res://images/)
	images = [
		load("res://gamejam concept/IMG_0825.PNG"),
		load("res://gamejam concept/IMG_0826.PNG"),
		load("res://gamejam concept/IMG_0827.PNG"),
		load("res://gamejam concept/IMG_0828.PNG"),
		load("res://gamejam concept/IMG_0829.PNG"),
		load("res://gamejam concept/IMG_0830.PNG"),
		load("res://gamejam concept/IMG_0832.PNG"),
		load("res://gamejam concept/IMG_0833.PNG"),
		load("res://gamejam concept/IMG_0834.PNG"),
		load("res://gamejam concept/IMG_0835.PNG")
	]
	_update_image()
	
	btn_prev.pressed.connect(_on_prev_pressed)
	btn_next.pressed.connect(_on_next_pressed)

func _update_image() -> void:
	image.texture = images[current_index]

func _on_prev_pressed() -> void:
	current_index -= 1
	if current_index < 0:
		current_index = images.size() - 1  # vuelve al final
	_update_image()

func _on_next_pressed() -> void:
	current_index += 1
	if current_index >= images.size():
		current_index = 0  # vuelve al principio
	_update_image()
