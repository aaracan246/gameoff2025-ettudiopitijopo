extends Control

@onready var label: Label = $Label
@onready var newspaper_1: Sprite2D = $Container/newspaper_1
@onready var newspaper_2: Sprite2D = $Container/newspaper_2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.modulate.a = 0
	newspaper_1.modulate.a = 0
	newspaper_2.modulate.a = 0
	
	var tween = create_tween()
	
	# Label
	tween.tween_property(label, "modulate:a", 1.0, 2.0)
	tween.tween_property(label, "modulate:a", 0.0, 2.0).set_delay(1)
	
	# Newspaper_1
	tween.tween_property(newspaper_1, "modulate:a", 1.0, 2.0).set_delay(1)
	AudioManager.newspaper.play()
	
	tween.tween_property(newspaper_1, "modulate:a", 0.0, 2.0).set_delay(5)
	
	# Newspaper_1
	tween.tween_property(newspaper_2, "modulate:a", 1.0, 2.0).set_delay(1)
	AudioManager.newspaper.play()
	tween.tween_property(newspaper_2, "modulate:a", 0.0, 2.0).set_delay(5)
	
	await tween.finished
	await get_tree().create_timer(1.0).timeout
	
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")
	
	
	
	
