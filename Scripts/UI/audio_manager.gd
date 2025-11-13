extends Node

# == MUSIC == #
@onready var main_menu: AudioStreamPlayer = $Music/main_menu
@onready var credits: AudioStreamPlayer = $Music/credits
@onready var scene_transition: AudioStreamPlayer = $Music/scene_transition

# == SFX == #
@onready var hover: AudioStreamPlayer = $SFX/hover
@onready var newspaper_drop: AudioStreamPlayer = $SFX/newspaper_drop
@onready var newspaper_pickup: AudioStreamPlayer = $SFX/newspaper_pickup
@onready var chair_roll: AudioStreamPlayer = $SFX/chair_roll
@onready var phone_ring: AudioStreamPlayer = $SFX/phone_ring
@onready var phone_pickup: AudioStreamPlayer = $SFX/phone_pickup
@onready var phone_down: AudioStreamPlayer = $SFX/phone_down
@onready var click: AudioStreamPlayer = $SFX/click
@onready var pc_alert: AudioStreamPlayer = $SFX/pc_alert
@onready var lamp_on: AudioStreamPlayer = $SFX/lamp_on
@onready var lamp_off: AudioStreamPlayer = $SFX/lamp_off


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
	
