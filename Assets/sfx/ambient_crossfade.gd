extends Node
# Reproduce de forma continua un audio de ambiente usando dos AudioStreamPlayer.
# Cuando la pista actual está por terminar, empieza la siguiente encima (crossfade) para que el bucle sea imperceptible, evitando cortes o silencios.

@onready var ambient_a: AudioStreamPlayer = $ambient_a
@onready var ambient_b: AudioStreamPlayer = $ambient_b

const OVERLAP_TIME := 5.0

var current
var next

func _ready():
	current = ambient_a
	next = ambient_b
	current.play()

func _process(_delta):
	if current.playing:
		var remaining = current.stream.get_length() - current.get_playback_position()
		if remaining <= OVERLAP_TIME and not next.playing:
			next.play()
		elif remaining <= 0.1:
			current.stop()
			var temp = current
			current = next
			next = temp
