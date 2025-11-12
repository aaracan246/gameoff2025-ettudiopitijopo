extends VBoxContainer


@onready var master_btn: Button = $Master/Master_btn
@onready var master_slider: HSlider = $Master/Master_HSlider

@onready var music_btn: Button = $Music/Music_btn
@onready var music_slider: HSlider = $Music/Music_HSlider

@onready var sfx_btn: Button = $SFX/SFX_btn
@onready var sfx_slider: HSlider = $SFX/SFX_HSlider

var buttons := {
	"Master": master_btn,
	"Music": music_btn,
	"SFX": sfx_btn
}
# == ICONS ==
const MUTE_W = preload("uid://dk8uu4xhqpmjv")
const LOW_VOLUME_W = preload("uid://3k62ka6dietx")
const MEDIUM_VOLUME_W = preload("uid://b34gwdqpfiarh")
const FULL_VOLUME_W = preload("uid://b61q8sp1xmxxq")

var lv_master = 0

const MIN_DB = -60.0
const MAX_DB = 0.0

func _ready():
	_sync_sliders()

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
	var db = _slider_to_db(value)
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(bus_index, db <= MIN_DB)
	

func _mute(bus_name: String):
	var bus_index = AudioServer.get_bus_index(bus_name)
	print(AudioServer.get_bus_volume_db(bus_index))
	AudioServer.set_bus_mute(bus_index, true)
	

func _sync_sliders():
	master_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	music_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sfx_slider.value = _db_to_slider(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))


# BUTTONS AND SLIDER ACTIONS
func _on_master_h_slider_value_changed(value: float) -> void:
	_set_volume("Master", value)

func _on_music_h_slider_value_changed(value: float) -> void:
	_set_volume("Music", value)

func _on_sfx_h_slider_value_changed(value: float) -> void:
	_set_volume("SFX", value)
	

var volume_states := {
	"Master": true,
	"Music": true,
	"SFX": true
}

var volume_levels := {
	"Master": 100.0,
	"Music": 100.0,
	"SFX": 100.0
}

	
		
## --- TOGGLE VOLUME ---
func _toggle_volume(bus_name: String, slider: HSlider = null) -> void:
	volume_states[bus_name] = !volume_states[bus_name]

	if volume_states[bus_name]:
		_set_volume(bus_name, volume_levels[bus_name])
		if slider: slider.value = volume_levels[bus_name]
	else:
		_set_volume(bus_name, MIN_DB)
		if slider: slider.value = 0


# --- HANDLERS DE BOTONES ---
func _on_master_btn_pressed() -> void:
	_toggle_volume("Master", master_slider)

func _on_music_btn_pressed() -> void:
	_toggle_volume("Music", music_slider)

func _on_sfx_button_pressed() -> void:
	_toggle_volume("SFX", sfx_slider)
