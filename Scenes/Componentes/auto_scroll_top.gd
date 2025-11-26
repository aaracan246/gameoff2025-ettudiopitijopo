extends RichTextLabel

func _ready():
	await get_tree().process_frame
	scroll_to_line(0)
