extends Control

@onready var continue_btn: Button = $play_btn
@onready var settings_btn: Button = $settings_btn
@onready var credits_btn: Button = $credits_btn

@onready var settings_menu: Control = $settings_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.visible = false
	AudioManager.main_menu.play()
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		AudioManager.click.play()
	
		
# === ON PRESSED === #

func _on_play_btn_pressed() -> void:
	AudioManager.fade_out(AudioManager.main_menu, 2.0)
	AudioManager.scene_transition.play()
	get_tree().change_scene_to_file("res://Scenes/UI/loading.tscn")
	
func _on_settings_btn_pressed() -> void:
	settings_menu.visible = true

func _on_credits_pressed() -> void:
	AudioManager.fade_out(AudioManager.main_menu, 2.0)
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")


# == HOVER SOUND == #
func _on_play_btn_mouse_entered() -> void:
	continue_btn.add_theme_font_size_override("font_size", 70)
	AudioManager.hover.play()
	
func _on_settings_btn_mouse_entered() -> void:
	settings_btn.add_theme_font_size_override("font_size", 70)
	AudioManager.hover.play()

func _on_credits_mouse_entered() -> void:
	credits_btn.add_theme_font_size_override("font_size", 70)
	AudioManager.hover.play()


#------------------------
func _on_play_btn_mouse_exited() -> void:
	continue_btn.add_theme_font_size_override("font_size", 50)


func _on_settings_btn_mouse_exited() -> void:
	settings_btn.add_theme_font_size_override("font_size", 50)


func _on_credits_btn_mouse_exited() -> void:
	credits_btn.add_theme_font_size_override("font_size", 50)
