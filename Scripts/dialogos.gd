extends Control

@onready var character: Label = $Panel/VBoxContainer/Character
@onready var text: RichTextLabel = $Panel/VBoxContainer/Text

@export var dialogo = [
	"[shake]Tengo miedo[/shake] que sustoo",
	"[wave]Holaaaaaa[/wave]"
]

var dialog_index := 0
var writing := false
var speed := 0.02 

func _ready():
	text.bbcode_enabled = true
	text.visible_characters = 0

func _process(_delta):
	if Input.is_action_just_pressed("next") and not writing:
		if dialog_index < dialogo.size():
			start_dialog(dialogo[dialog_index])
			dialog_index += 1


func start_dialog(msg: String):
	writing = true
	text.bbcode_text = msg
	text.visible_characters = 0

	var total := text.get_total_character_count()

	for i in range(total + 1):
		text.visible_characters = i
		await get_tree().create_timer(speed).timeout

	writing = false
