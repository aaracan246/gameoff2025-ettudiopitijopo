extends Control


@onready var life_lost_1: Sprite2D = $MarginContainer/BoxContainer/HBoxContainer/life_1
@onready var life_lost_2: Sprite2D = $MarginContainer/BoxContainer/HBoxContainer/life_2
const LIFE_LOST = preload("uid://bcss78ks18dp4")


func lost_1() -> void: 
	life_lost_1.texture = LIFE_LOST 
	
func lost_2() -> void: 
	life_lost_2.texture = LIFE_LOST 
