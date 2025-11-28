extends Control

@onready var newspaper_1: Sprite2D = $newspaper/newspaper1 # Pierdes todas las vidas
@onready var newspaper_2: Sprite2D = $newspaper/newspaper2 # Te pilla el asesino
@onready var newspaper_3: Sprite2D = $newspaper/newspaper3
@onready var newspaper: Node = $newspaper

const BAD_ENDING = preload("uid://fhj0ckg2m2xe")
const GOOD_ENDING = preload("uid://dmk2pehvlv2bn")

const AWELA_BAD_ENDING = preload("uid://b1aqk4qctledr")
const AWELA_GOOD_ENDING = preload("uid://cv7itin777exy")

const CAMPER_BAD_ENDING = preload("uid://bllvih1ohi4pd")
const CAMPER_GOOD_ENDING = preload("uid://dadc4gkoau3n1")

@onready var label: Label = $Label

func _ready() -> void:
	# Cambia el newspaper dependiendo del final
	if Global.game_over == 1:
		# Mueres
		newspaper_1.texture = BAD_ENDING
	else:
		
		newspaper_1.texture = GOOD_ENDING

	if Global.dead_awela:
		newspaper_2.texture = AWELA_BAD_ENDING
	else:
		newspaper_2.texture = AWELA_GOOD_ENDING


	if Global.dead_awela:
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
	AudioManager.game_over_2.play()
	var label_in = create_tween()
	label_in.tween_property(label, "modulate:a", 1.0, 2.0)
	await label_in.finished
	
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
	#var tween4 = create_tween()
	#tween4.tween_property(newspaper_1, "texture", newspaper_2.texture, 1.0)
	#tween4.tween_property(newspaper_2, "texture", newspaper_3.texture, 1.0)

	AudioManager.newspaper.play()
	#await tween4.finished
	
	await get_tree().create_timer(3).timeout
	
	var tween8 = create_tween()
	tween8.tween_property(newspaper, "modulate:a", 0.0, 2.0)
	await tween8.finished
	#var tween9 = create_tween()
	#tween9.tween_property(newspaper, "modulate:a", 0.0, 2.0)
	#await tween9.finished
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu.tscn")
