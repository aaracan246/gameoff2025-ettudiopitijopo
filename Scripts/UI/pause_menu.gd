extends Control
@onready var pause_menu: Control = $"."

@onready var resume_btn: Button = $VBoxContainer/resume_btn
@onready var settings_btn: Button = $VBoxContainer/settings_btn
@onready var exit_btn: Button = $VBoxContainer/exit_btn

@onready var confirm_exit: ConfirmationDialog = $confirm_exit
@onready var settings: Control = $settings

func _ready() -> void:
	confirm_exit.visible = false
	settings.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		AudioManager.click.play()
		
# Se llama desde el CanvasLayer
func toggle_pause():
	if get_tree().paused:
		resume_game()
	else:
		pause_game()


func pause_game():
	get_tree().paused = true
	pause_menu.visible = true
	
func resume_game():
	get_tree().paused = false
	pause_menu.visible = false
	settings.visible = false
	
	
# Main buttons
func _on_resume_btn_pressed() -> void:
	resume_game()

func _on_settings_btn_pressed() -> void:
	settings.visible = true
	
func _on_exit_btn_pressed() -> void:
	confirm_exit.visible = true

# confirm exit	
func _on_confirm_exit_confirmed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")

func _on_confirm_exit_canceled() -> void:
	confirm_exit.visible = false


func _on_resume_btn_mouse_entered() -> void:
		AudioManager.hover.play()

func _on_settings_btn_mouse_entered() -> void:
	AudioManager.hover.play()

func _on_exit_btn_mouse_entered() -> void:
	AudioManager.hover.play()
