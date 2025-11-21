extends Control

signal vhs_filter_changed(value:bool)
@onready var settings: Control = $"."

@onready var check = $PanelContainer/MarginContainer/Container/HBoxContainer/VHS/CheckButton
@onready var close: Button = $PanelContainer/MarginContainer/Container/Header/close


func _ready() -> void:
	check.button_pressed = Global.vhs_enabled

func _on_close_pressed() -> void:
	settings.visible = false
	
	
func _on_check_button_pressed() -> void:
	Global.vhs_enabled = check.button_pressed
	emit_signal("vhs_filter_changed", check.button_pressed)


func _on_master_btn_pressed() -> void:
	pass # Replace with function body.
