extends StaticBody3D

@onready var video_sounds = {
	"peter_left":{"video":GO_LEFT_GHOST,"audio":GO_LEFT_FINAL, "color":RED} ,
	"peter_behind":{"video":BEHIND_YOU_GHOST,"audio":BEHIND_YOU_FINAL, "color":RED},
	"peter_middle":{"video":MIDLE_PATH_GHOST,"audio":MIDDLE_PATH_FINAL, "color":RED},
	"peter_right":{"video":TURN_RIGHT_GHOST,"audio":TURN_RIGHT_FINAL, "color":RED},
	"peter_back":{"video":TURN_BACK_GHOST,"audio":TURN_BACK_FINAL, "color":RED},
	
	"nico_left":{"video":GO_LEFT_GHOST_ONDA_1,"audio":GO_LEFT_FINAL, "color":RED} ,
	"nico_behind":{"video":BEHIND_YOU_GHOST_ONDA,"audio":BEHIND_YOU_FINAL, "color":RED},
	"nico_middle":{"video":MIDLE_PATH_ONDA_1,"audio":MIDDLE_PATH_FINAL, "color":RED},
	"nico_right":{"video":TURN_RIGHT_ONDA,"audio":TURN_RIGHT_FINAL, "color":RED},
	"nico_back":{"video":TURN_BACK_GHOST,"audio":TURN_BACK_FINAL, "color":RED},
	
	"eva_left":{"video":GO_LEFT_GHOST,"audio":GO_LEFT_FINAL, "color":GREEN} ,
	"eva_behind":{"video":BEHIND_YOU_GHOST,"audio":BEHIND_YOU_FINAL, "color":GREEN},
	"eva_middle":{"video":MIDLE_PATH_GHOST,"audio":MIDDLE_PATH_FINAL, "color":GREEN},
	"eva_right":{"video":TURN_RIGHT_GHOST,"audio":TURN_RIGHT_FINAL, "color":GREEN},
	"eva_back":{"video":TURN_BACK_GHOST,"audio":TURN_BACK_FINAL, "color":GREEN},
	
	"johanna_left":{"video":GO_LEFT_GHOST_ONDA_1,"audio":GO_LEFT_FINAL, "color":RED} ,
	"johanna_behind":{"video":BEHIND_YOU_GHOST_ONDA,"audio":BEHIND_YOU_FINAL, "color":RED},
	"johanna_middle":{"video":MIDLE_PATH_ONDA_1,"audio":MIDDLE_PATH_FINAL, "color":RED},
	"johanna_right":{"video":TURN_RIGHT_ONDA,"audio":TURN_RIGHT_FINAL, "color":RED},
	"johanna_back":{"video":TURN_BACK_GHOST,"audio":TURN_BACK_FINAL, "color":RED},
	
	"default":{"video":BUZZ_ONDA,"audio":THE_BUZZER_2__7481_KHZ__DUTCH_PIRATE},

	#QUITAR ESTO CUANDO CAMBIEIS LAS SEÑALES DE LOS DIALOGOS
	
	"fem_left":{"video":GO_LEFT_GHOST_ONDA_1,"audio":FEM_GO_LEFT_TRUE} ,
	"fem_behind":{"video":BEHIND_YOU_GHOST_ONDA,"audio":FEM_BEHIND_YOU_TRUE},
	"fem_middle":{"video":MIDLE_PATH_ONDA_1,"audio":FEM_MIDDLE_PATH_TRUE},
	"fem_right":{"video":TURN_RIGHT_ONDA,"audio":FEM_TURN_RIGHT_TRUE},
	
	"man_left":{"video":GO_LEFT_GHOST,"audio":GO_LEFT_FINAL} ,
	"man_behind":{"video":BEHIND_YOU_GHOST,"audio":BEHIND_YOU_FINAL},
	"man_middle":{"video":MIDLE_PATH_GHOST,"audio":MIDDLE_PATH_FINAL},
	"man_right":{"video":TURN_RIGHT_GHOST,"audio":TURN_RIGHT_FINAL},
	"man_back":{"video":TURN_BACK_GHOST,"audio":TURN_BACK_FINAL}
	#HASTA AQUI
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
#PICUDAS
const BEHIND_YOU_GHOST_ONDA = preload("res://Assets/radio ondas/video/ondas_picudas/behind_you_ghost_onda.ogv")
const BUZZ_ONDA = preload("uid://c6y6vk5xb7xfx")
const GO_LEFT_GHOST_ONDA_1 = preload("uid://fqmmln03j3h0")
const MIDLE_PATH_ONDA_1 = preload("uid://dpcmgvqfwfcp4")
const TURN_BACK_ONDA = preload("res://Assets/radio ondas/video/ondas_picudas/turn_back_onda.ogv")
const TURN_RIGHT_ONDA = preload("uid://bpowpjqd37lpw")

#RECTAS
const BEHIND_YOU_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/behind_you_ghost.ogv")
const BUZZ = preload("res://Assets/radio ondas/video/ondas_rectas/buzz.ogv")
const GO_LEFT_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/go_left_ghost.ogv")
const MIDLE_PATH_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/midle_path_ghost.ogv")
const TURN_BACK_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/turn_back_ghost.ogv")
const TURN_RIGHT_GHOST = preload("res://Assets/radio ondas/video/ondas_rectas/turn_right_ghost.ogv")

const RED = Color.RED
const  GREEN = Color.GREEN

@onready var video_stream_player: VideoStreamPlayer = $SubViewport2/VideoStreamPlayer

@onready var sounds: AudioStreamPlayer3D = $sounds

@onready var red: OmniLight3D = $red
@onready var green: OmniLight3D = $green

func _ready() -> void:
	change_video("default")
	pass

func change_video(_name:String):
	if _name not in video_sounds:
		return 
	if video_sounds[_name]:
		video_stream_player.stream = video_sounds[_name]["video"]
		sounds.stream = video_sounds[_name]["audio"]
		video_stream_player.play()
		sounds.play()
		if _name == "default":
			sounds.volume_db = -10
			red.visible = false
			green.visible = false
			
		else:
			sounds.volume_db = 0
			if video_sounds[_name]["color"] == RED:
				red.visible = true
			elif video_sounds[_name]["color"] == GREEN:
				green.visible = true
		

func _on_video_stream_player_finished() -> void:
	change_video("default")


func _on_sounds_finished() -> void:
	change_video("default")
