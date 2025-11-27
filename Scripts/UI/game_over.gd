extends Control

@onready var newspaper_1: Sprite2D = $newspaper1 # Pierdes todas las vidas
@onready var newspaper_2: Sprite2D = $newspaper2 # Te pilla el asesino

@onready var label: Label = $Label
var newspaper

func _ready() -> void:
	# Cambia el newspaper dependiendo del final
	newspaper = newspaper_1 if Global.game_over == 1 else newspaper_2

	# Inicialmente invisible
	newspaper.modulate.a = 0
	label.modulate.a = 0
	
	await get_tree().create_timer(1.0).timeout
	
	# Fade-in del sprite
	var tween = create_tween()
	tween.tween_property(newspaper, "modulate:a", 1.0, 2.0)
	AudioManager.newspaper.play()
	await tween.finished
	
	await get_tree().create_timer(5.0).timeout
	
	# Fade-out del sprite
	tween = create_tween()
	tween.tween_property(newspaper, "modulate:a", 0.0, 2.0)
	await tween.finished
	
	await get_tree().create_timer(2.0).timeout
	
	# Fade-in del label
	AudioManager.game_over_2.play()
	tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 2.0)
	await tween.finished
	
	await get_tree().create_timer(5.0).timeout
	
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
