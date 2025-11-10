extends Node

@onready var main_menu: AudioStreamPlayer = $main_menu

func fade_out(player: AudioStreamPlayer, duration: float = 3.0) -> void:
	if not player:
		return

	# Crear tween "inline" sin añadir al árbol
	var t = create_tween()
	t.tween_property(player, "volume_db", -80, duration)
	t.finished.connect(func():
		player.stop()
	)
