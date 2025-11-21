extends Control

signal vhs_filter_changed(value:bool)
@onready var settings: Control = $"."

@onready var check = $PanelContainer/MarginContainer/Container/HBoxContainer/VHS/CheckButton
@onready var close: Button = $PanelContainer/MarginContainer/Container/Header/close

@onready var audio = get_node("/root/AudioManager")


func _ready() -> void:
	check.button_pressed = Global.vhs_enabled

func _on_close_pressed() -> void:
	settings.visible = false
	
	
func _on_check_button_pressed() -> void:
	Global.vhs_enabled = check.button_pressed
	emit_signal("vhs_filter_changed", check.button_pressed)
