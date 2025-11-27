extends Control

@onready var label: Label = $Label
@onready var newspaper: Sprite2D = $Container/newspaper

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.modulate.a = 0
	newspaper.modulate.a = 0
	
	var tween = create_tween()
	
	# Label
	tween.tween_property(label, "modulate:a", 1.0, 2.0)
	tween.tween_property(label, "modulate:a", 0.0, 2.0).set_delay(1)
	
	await tween.finished
	
	# Newspaper
	var tween2 = create_tween()
	tween2.tween_property(newspaper, "modulate:a", 1.0, 2.0)
	AudioManager.newspaper.play()
	var tween3 = create_tween()
	tween3.tween_property(newspaper, "modulate:a", 0.0, 2.0).set_delay(5)
	

	await tween3.finished
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")
	
	
	
	
