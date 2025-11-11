extends Control
@onready var settings: Control = $"."

@onready var blurr: Button = $Blurr
@onready var close: Button = $PanelContainer/MarginContainer/Container/Header/close


func _on_close_pressed() -> void:
	settings.visible = false
	
func _on_blurr_pressed() -> void:
	settings.visible = false
