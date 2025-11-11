extends Control

@onready var continue_btn: Button = $VBoxContainer/continue_btn
@onready var settings_btn: Button = $VBoxContainer/settings_btn
@onready var credits_btn: Button = $VBoxContainer/credits_btn

@onready var settings_menu: Control = $settings_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	settings_menu.visible = false
	AudioManager.main_menu.play()

# === ON PRESSED === #
func _on_continue_btn_pressed() -> void:
	AudioManager.fade_out(AudioManager.main_menu, 2.0)
	get_tree().change_scene_to_file("res://Scenes/UI/loading.tscn")

# PRUEBA DE AUDIO
func _on_new_game_btn_pressed() -> void:
	AudioManager.fade_out(AudioManager.main_menu, 2.0)
	AudioManager.scene_transition.play()
	get_tree().change_scene_to_file("res://Assets/sfx/pruebasam.tscn")
	
	
func _on_settings_btn_pressed() -> void:
	settings_menu.visible = true

func _on_credits_pressed() -> void:
	AudioManager.fade_out(AudioManager.main_menu, 2.0)
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")


# == HOVER SOUND == #
func _on_continue_btn_mouse_entered() -> void:
	AudioManager.hover.play()
	
func _on_new_game_btn_mouse_entered() -> void:
	AudioManager.hover.play()

func _on_settings_btn_mouse_entered() -> void:
	AudioManager.hover.play()

func _on_credits_mouse_entered() -> void:
	AudioManager.hover.play()
