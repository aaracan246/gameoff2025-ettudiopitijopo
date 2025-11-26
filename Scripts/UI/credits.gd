extends Control

@onready var credits: RichTextLabel = $RichTextLabel

var speed : float = 60.0  # píxeles por segundo

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	#AudioManager.credits.play()

func _process(delta):
	credits.position.y -= speed * delta
	
	# Cuando salga por arriba cambia de escena
	if credits.position.y + credits.size.y < 0:
		AudioManager.fade_out(AudioManager.credits, 15)
		get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
