extends VBoxContainer

@onready var master_slider: HSlider = $Master/Master_Slider
@onready var music_slider: HSlider = $Music/Music_Slider
@onready var sfx_slider: HSlider = $SFX/SFX_Slider
@onready var master_btn: Button = $Master/Master_btn
@onready var music_btn: Button = $Music/Music_btn
@onready var sfx_btn: Button = $SFX/SFX_btn

const MIN_DB = -60.0
const MAX_DB = 0.0

var _ignore_slider = false

# ICONS
const MUTE_W = preload("uid://c38uibu5o73gx")
const NO_VOLUME_W = preload("uid://dk8uu4xhqpmjv")
const LOW_VOLUME_W = preload("uid://3k62ka6dietx")
const MEDIUM_VOLUME_W = preload("uid://b34gwdqpfiarh")
const FULL_VOLUME_W = preload("uid://b61q8sp1xmxxq")


func _ready():
	_sync_sliders()
	
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	
	

func _sync_sliders():
	master_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	ch_icon( "Master", master_btn)
	ch_icon( "Music", music_btn)
	ch_icon( "SFX", sfx_btn)

func _slider_to_db(value: float) -> float:
	if value <= 0.0:
		return MIN_DB
	
	var linear = value / 100.0
	var db = linear_to_db(linear)
	return clamp(db, MIN_DB, MAX_DB)

func _db_to_slider(db: float) -> float:
	if db <= MIN_DB:
		return 0.0
	var linear = db_to_linear(db)
	return clamp(linear * 100.0, 0.0, 100.0)

func _set_volume(bus_name: String, value: float):
	if _ignore_slider: # Viene del botón de mute
		return
		
	var db = _slider_to_db(value)
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus_index, db)
	AudioServer.set_bus_mute(bus_index, db <= MIN_DB)


# == SLIDERS AND BUTTONS ==
func _on_master_volume_changed(value: float):
	_set_volume("Master", value)
	ch_icon( "Master", master_btn)

func _on_music_volume_changed(value: float):
	_set_volume("Music", value)
	ch_icon( "Music", music_btn)

func _on_sfx_volume_changed(value: float):
	_set_volume("SFX", value)
	ch_icon( "SFX", sfx_btn)

func _on_master_btn_pressed() -> void:
	_toggle_mute("Master", master_slider)

func _on_music_btn_pressed() -> void:
	_toggle_mute("Music", music_slider)

func _on_sfx_btn_pressed() -> void:
	_toggle_mute("SFX", sfx_slider)


func _toggle_mute(bus_name: String, slider: HSlider):
	var bus = AudioServer.get_bus_index(bus_name)
	var is_muted = AudioServer.is_bus_mute(bus)

	AudioServer.set_bus_mute(bus, not is_muted)

	if not is_muted:
		# Mute
		_ignore_slider = true
		slider.value = 0.0
		_ignore_slider = false
	else:
		# Desmute
		var db = AudioServer.get_bus_volume_db(bus)
		var restored_value = _db_to_slider(db)

		_ignore_slider = true
		slider.value = restored_value
		_ignore_slider = false


func ch_icon(bus_name: String, btn: Button):
	var bus = AudioServer.get_bus_index(bus_name)
	
	if AudioServer.is_bus_mute(bus):
		btn.icon = MUTE_W
		return

	var db = AudioServer.get_bus_volume_db(bus)
	var slider_val = _db_to_slider(db)

	if slider_val <= 10:
		btn.icon = NO_VOLUME_W
	elif slider_val <= 30:
		btn.icon = LOW_VOLUME_W
	elif slider_val <= 70:
		btn.icon = MEDIUM_VOLUME_W
	else:
		btn.icon = FULL_VOLUME_W
	
