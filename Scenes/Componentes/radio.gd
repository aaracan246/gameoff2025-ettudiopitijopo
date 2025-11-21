extends StaticBody3D

@onready var video_sounds = {
	"fem_left":{"video":GO_LEFT_GHOST_ONDA_1,"audio":FEM_GO_LEFT_TRUE} ,
	"fem_behind":{"video":BEHIND_YOU_GHOST_ONDA,"audio":FEM_BEHIND_YOU_TRUE},
	"fem_middle":{"video":MIDLE_PATH_ONDA_1,"audio":FEM_MIDDLE_PATH_TRUE},
	"fem_right":{"video":TURN_RIGHT_ONDA,"audio":FEM_TURN_RIGHT_TRUE},
	
	"man_left":{"video":GO_LEFT_GHOST,"audio":GO_LEFT_FINAL} ,
	"man_behind":{"video":BEHIND_YOU_GHOST,"audio":BEHIND_YOU_FINAL},
	"man_middle":{"video":MIDLE_PATH_GHOST,"audio":MIDDLE_PATH_FINAL},
	"man_right":{"video":TURN_RIGHT_GHOST,"audio":TURN_RIGHT_FINAL},
	"man_back":{"video":TURN_BACK_GHOST,"audio":TURN_BACK_FINAL},
	"default":{"video":BUZZ_ONDA,"audio":THE_BUZZER_2__7481_KHZ__DUTCH_PIRATE}
}

#AUDIOS
const FEM_BEHIND_YOU_TRUE = preload("uid://bb3wp74k18ctc")
const FEM_GO_LEFT_TRUE = preload("uid://bldbudjqmlo8p")
const FEM_MIDDLE_PATH_TRUE = preload("uid://be4bj2scu2f43")
const FEM_TURN_RIGHT_TRUE = preload("uid://c2g8akck6x7y0")

const BEHIND_YOU_FINAL = preload("uid://d3s5jd0401125")
const GO_LEFT_FINAL = preload("uid://ckribe22tvdnb")
const MIDDLE_PATH_FINAL = preload("uid://b7u4pr1ls3gmr")
const THE_BUZZER_2__7481_KHZ__DUTCH_PIRATE = preload("uid://bacge6oaouufw")
const TURN_BACK_FINAL = preload("uid://ddjqh15b04ar8")
const TURN_RIGHT_FINAL = preload("uid://clkioqrea0adv")


#VIDEOS
const BEHIND_YOU_GHOST_ONDA = preload("res://Assets/radio ondas/video/ondas_picudas/behind_you_ghost_onda.ogv")
const BUZZ_ONDA = preload("uid://c6y6vk5xb7xfx")
const GO_LEFT_GHOST_ONDA_1 = preload("uid://fqmmln03j3h0")
const MIDLE_PATH_ONDA_1 = preload("uid://dpcmgvqfwfcp4")
const TURN_BACK_ONDA = preload("res://Assets/radio ondas/video/ondas_picudas/turn_back_onda.ogv")
const TURN_RIGHT_ONDA = preload("uid://bpowpjqd37lpw")

const BEHIND_YOU_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/behind_you_ghost.ogv")
const BUZZ = preload("res://Assets/radio ondas/video/ondas_rectas/buzz.ogv")
const GO_LEFT_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/go_left_ghost.ogv")
const MIDLE_PATH_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/midle_path_ghost.ogv")
const TURN_BACK_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/turn_back_ghost.ogv")
const TURN_RIGHT_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/turn_right_ghost.ogv")


@onready var video_stream_player: VideoStreamPlayer = $SubViewport2/VideoStreamPlayer

@onready var sounds: AudioStreamPlayer3D = $sounds


func _ready() -> void:
	change_video("default")
	pass

func change_video(_name:String):
	if video_sounds[_name]:
		video_stream_player.stream = video_sounds[_name]["video"]
		sounds.stream = video_sounds[_name]["audio"]
		video_stream_player.play()
		sounds.play()


func _on_video_stream_player_finished() -> void:
	change_video("default")


func _on_sounds_finished() -> void:
	change_video("default")
