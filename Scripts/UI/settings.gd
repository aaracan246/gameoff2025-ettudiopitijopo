extends Control

signal vhs_filter_changed(value:bool)

signal interactive_object


@onready var settings: Control = $"."

@onready var check = $PanelContainer/MarginContainer/Container/HBoxContainer/VHS/CheckButton

@onready var close: Button = $PanelContainer/MarginContainer/Container/Header/close
@onready var master_btn: Button = $PanelContainer/MarginContainer/Container/HBoxContainer/Volume/Master/Master_btn
@onready var master_slider: HSlider = $PanelContainer/MarginContainer/Container/HBoxContainer/Volume/Master/Master_Slider
@onready var music_btn: Button = $PanelContainer/MarginContainer/Container/HBoxContainer/Volume/Music/Music_btn
@onready var music_slider: HSlider = $PanelContainer/MarginContainer/Container/HBoxContainer/Volume/Music/Music_Slider
@onready var sfx_btn: Button = $PanelContainer/MarginContainer/Container/HBoxContainer/Volume/SFX/SFX_btn
@onready var sfx_slider: HSlider = $PanelContainer/MarginContainer/Container/HBoxContainer/Volume/SFX/SFX_Slider
@onready var check_button: CheckButton = $PanelContainer/MarginContainer/Container/HBoxContainer/VHS/CheckButton
@onready var option_button: OptionButton = $PanelContainer/MarginContainer/Container/HBoxContainer/VHS/OptionButton


@onready var audio = get_node("/root/AudioManager")


func _ready() -> void:
	var popup =option_button.get_popup()
	for node in [close,master_btn,master_slider,music_btn,music_slider,sfx_btn,sfx_slider,check_button,option_button,popup]:
		node.mouse_entered.connect(_mouse_entered_area)
		node.mouse_exited.connect(_mouse_exited_area)
	check.button_pressed = Global.vhs_enabled

func _mouse_entered_area():
	emit_signal("interactive_object",true)

func _mouse_exited_area():
	emit_signal("interactive_object",false)

func _on_close_pressed() -> void:
	settings.visible = false
	
	
func _on_check_button_pressed() -> void:
	Global.vhs_enabled = check.button_pressed
	emit_signal("vhs_filter_changed", check.button_pressed)




func _on_option_button_item_selected(index):
	match index:
		0: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			
		1: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
		2: 
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
