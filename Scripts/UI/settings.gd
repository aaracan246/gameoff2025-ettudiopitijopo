extends Control
@onready var settings: Control = $"."

@onready var close: Button = $close



func _on_close_pressed() -> void:
	settings.visible = false
