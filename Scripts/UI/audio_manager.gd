extends Node

# == MUSIC == #
@onready var main_menu: AudioStreamPlayer = $Music/main_menu
@onready var credits: AudioStreamPlayer = $Music/credits
@onready var scene_transition: AudioStreamPlayer = $Music/scene_transition

# == SFX == #
@onready var hover: AudioStreamPlayer = $SFX/hover
@onready var click: AudioStreamPlayer = $SFX/click
@onready var newspaper_drop: AudioStreamPlayer = $SFX/newspaper_drop
@onready var newspaper_pickup: AudioStreamPlayer = $SFX/newspaper_pickup
@onready var chair_roll: AudioStreamPlayer = $SFX/chair_roll
@onready var phone_ring: AudioStreamPlayer = $SFX/phone_ring
@onready var phone_pickup: AudioStreamPlayer = $SFX/phone_pickup
@onready var phone_down: AudioStreamPlayer = $SFX/phone_down
@onready var phone_beep: AudioStreamPlayer = $SFX/phone_beep
@onready var lamp_on: AudioStreamPlayer = $SFX/lamp_on
@onready var lamp_off: AudioStreamPlayer = $SFX/lamp_off
@onready var pc_click: AudioStreamPlayer = $SFX/pc_click
@onready var pc_alert: AudioStreamPlayer = $SFX/pc_alert
@onready var ghost_1: AudioStreamPlayer = $SFX/ghost_1
@onready var book_glitch: AudioStreamPlayer = $SFX/book_glitch
@onready var windows_error: AudioStreamPlayer = $SFX/windows_error
@onready var door_closing: AudioStreamPlayer = $SFX/door_closing
@onready var door_opening: AudioStreamPlayer = $SFX/door_opening




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
	
