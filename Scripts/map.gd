extends StaticBody3D
@onready var pin_cafe: Node3D = $pin_cafe
@onready var pin_puerto: Node3D = $pin_puerto
@onready var pin_merendero: Node3D = $pin_merendero
@onready var pin_parking: Node3D = $pin_parking


func _ready() -> void:
	restart_pins_visivility()
	Global.pin_active.connect(update_pins_visivility)


func update_pins_visivility():
	restart_pins_visivility()
	pin_cafe.visible = Global.pin_cafe
	pin_puerto.visible = Global.pin_puerto
	pin_merendero.visible = Global.pin_merendero
	pin_parking.visible = Global.pin_parking

func restart_pins_visivility():
	pin_cafe.visible = false
	pin_puerto.visible = false
	pin_merendero.visible = false
	pin_parking.visible = false
