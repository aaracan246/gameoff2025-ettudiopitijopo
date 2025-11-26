extends Control

@export var timer = 1

func _ready() -> void:
	await get_tree().create_timer(timer).timeout
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
