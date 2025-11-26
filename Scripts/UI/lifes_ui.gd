extends Control


@onready var life_lost_1: TextureRect = $HBoxContainer/Container/life_lost_1
@onready var life_lost_2: TextureRect = $HBoxContainer/Container2/life_lost_2

func lost_1() -> void: 
	life_lost_1.visible = true 
	
func lost_2() -> void: 
	life_lost_2.visible = true
