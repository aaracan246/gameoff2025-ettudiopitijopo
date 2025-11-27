extends Control


@onready var life_lost_1: TextureRect = $HBoxContainer/life_1
@onready var life_lost_2: TextureRect =$HBoxContainer/life_2
const LIFE_IDLE_2 = preload("res://Assets/pc/life_idle2.png")
const LIFE_LOST = preload("uid://wviefcqnb2gg")


func lost_1() -> void: 
	life_lost_1.texture = LIFE_LOST 
	
func lost_2() -> void: 
	life_lost_2.texture = LIFE_LOST 
