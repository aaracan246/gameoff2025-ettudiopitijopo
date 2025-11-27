extends Control

@onready var nico_lai: Sprite2D = $NicoLai
@onready var label: Label = $Label

func _ready() -> void:
	# Inicialmente invisible
	nico_lai.modulate.a = 0
	label.modulate.a = 0
	
	await get_tree().create_timer(1.0).timeout
	
	# Fade-in del sprite
	var tween = create_tween()
	tween.tween_property(nico_lai, "modulate:a", 1.0, 2.0)
	AudioManager.newspaper.play()
	await tween.finished
	
	await get_tree().create_timer(5.0).timeout
	
	# Fade-out del sprite
	tween = create_tween()
	tween.tween_property(nico_lai, "modulate:a", 0.0, 2.0)
	await tween.finished
	
	await get_tree().create_timer(2.0).timeout
	
	# Fade-in del label
	AudioManager.game_over_2.play()
	tween = create_tween()
	tween.tween_property(label, "modulate:a", 1.0, 2.0)
	await tween.finished
	
	await get_tree().create_timer(5.0).timeout
	
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
