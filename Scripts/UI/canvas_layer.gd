extends CanvasLayer

@onready var pause_menu: Control = $pause_menu
@onready var fade_out_color: ColorRect = $fade_out


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_menu.visible = false
	
func _input(event):
	if event.is_action_pressed("pause"):
		pause_menu.toggle_pause()

func fade_out():
	var fade_tween = create_tween()
	fade_tween.tween_property(fade_out_color, "color:a", 1, 3)
	await fade_tween.finished
