extends Node

@onready var main_menu: AudioStreamPlayer = $main_menu
@onready var credits: AudioStreamPlayer = $credits
@onready var hover: AudioStreamPlayer = $hover
@onready var scene_transition: AudioStreamPlayer = $scene_transition

func fade_out(player: AudioStreamPlayer, duration) -> void:
	if not player:
		return

	# Crear tween "inline" sin añadir al árbol
	var t = create_tween()
	t.tween_property(player, "volume_db", -80, duration)
	t.finished.connect(func():
		player.stop()
		player.volume_db = 0
	)
	
