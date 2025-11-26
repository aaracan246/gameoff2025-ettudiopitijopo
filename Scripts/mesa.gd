extends Node3D
var body_2: MeshInstance3D
@export var texture: Material 

func _ready() -> void:
	
	body_2 = $body2
	
	var material = body_2.get_active_material(0) 
	if texture:
		material = texture
	pass
