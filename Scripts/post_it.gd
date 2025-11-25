extends Node3D

@export var texture: Texture2D

@onready var sprite3d =$Sprite3D

func _ready() -> void:
	sprite3d.texture = texture
