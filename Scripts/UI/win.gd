extends Control

@onready var newspaper_1: Sprite2D = $newspaper/newspaper1 # Pierdes todas las vidas
@onready var newspaper_2: Sprite2D = $newspaper/newspaper2 # Te pilla el asesino
@onready var newspaper_3: Sprite2D = $newspaper/newspaper3
@onready var newspaper: Node = $newspaper

const BAD_ENDING = preload("res://Assets/periodicos/BAD ENDING.png")
const GOOD_ENDING = preload("res://Assets/periodicos/GOOD ENDING.png")

const AWELA_BAD_ENDING = preload("res://Assets/periodicos/AWELA BAD ENDING.png")
const AWELA_GOOD_ENDING = preload("res://Assets/periodicos/AWELA GOOD ENDING.png")

const CAMPER_BAD_ENDING = preload("res://Assets/periodicos/CAMPER BAD ENDING.png")
const CAMPER_GOOD_ENDING = preload("res://Assets/periodicos/CAMPER GOOD ENDING.png")

@onready var label: Label = $Label

func _ready() -> void:
	# Cambia el newspaper dependiendo del final
	if Global.game_over == 1:
		# Mueres
		newspaper_1.texture = BAD_ENDING
	else:
		
		newspaper_1.texture = GOOD_ENDING
	print("abuela muerta: %s" % Global.dead_awela)
	if Global.dead_awela:
		newspaper_2.texture = AWELA_BAD_ENDING
	else:
		newspaper_2.texture = AWELA_GOOD_ENDING

	print("camper muerta: %s" % Global.dead_camper)
	if Global.dead_camper:
		newspaper_3.texture = CAMPER_BAD_ENDING
	else:
		newspaper_3.texture = CAMPER_GOOD_ENDING


	# Inicialmente invisible
	newspaper.modulate.a = 0
	label.modulate.a = 0
	newspaper.visible = true
	
	await get_tree().create_timer(1.0).timeout
	
	
	animation()

func animation():
	# Fade-in del label
	var label_in = create_tween()
	label_in.tween_property(label, "modulate:a", 1.0, 2.0)
	await label_in.finished
	await get_tree().create_timer(3.0).timeout
	# Fade-out del label
	var tween2 = create_tween()
	tween2.tween_property(label, "modulate:a", 0.0, 2.0)
	await tween2.finished
	
	# Fade-in del sprite
	var tween3 = create_tween()
	tween3.tween_property(newspaper, "modulate:a", 1.0, 2.0)
	AudioManager.newspaper.play()
	await tween3.finished
	
	# Fade-out del label
	var tween5 = create_tween()
	tween5.tween_property(label, "modulate:a", 0.0, 2.0)
	await tween5.finished
	
	await get_tree().create_timer(3).timeout
	# PASAR PAGINA
	newspaper_1.texture = newspaper_2.texture
	var tween6 = create_tween()
	tween6.tween_property(newspaper_2, "modulate:a", 0.0, 2.0)
	await tween6.finished


	AudioManager.newspaper.play()
	
	await get_tree().create_timer(3).timeout
	
	var tween8 = create_tween()
	tween8.tween_property(newspaper, "modulate:a", 0.0, 2.0)
	await tween8.finished

	AudioManager.stop_all_players_in_bus("music")
	AudioManager.stop_all_players_in_bus("sfx")
	get_tree().change_scene_to_file("res://Scenes/UI/credits.tscn")
