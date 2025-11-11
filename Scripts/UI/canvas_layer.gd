extends CanvasLayer

@onready var pause_menu: Control = $pause_menu


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.toggle_pause()
