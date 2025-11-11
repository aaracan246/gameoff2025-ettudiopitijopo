extends StaticBody3D

@onready var entrada = $pinEntrada
@onready var merendero1 = $pinMerendero1
@onready var merendero2 = $pinMerendero2
@onready var parking = $pinParking
@onready var obras = $pinObras
@onready var cafe = $pinCafe
@onready var embarcadero = $pinEmbarcadero
@onready var descanso = $pinDescanso
@onready var rescate  = $pinRescate
@onready var mirador = $pinMirador

func _ready() -> void:
	entrada.visible = false

func restar_pins():
	entrada.visible = false
	merendero1.visible = false
	merendero2.visible = false
	parking.visible = false
	obras.visible = false
	cafe.visible = false
	embarcadero.visible = false
	descanso.visible = false
	rescate.visible = false
	mirador.visible = false

func _on_demo_entrada() -> void:
	restar_pins()
	entrada.visible = true


func _on_demo_cafe() -> void:
	restar_pins()
	cafe.visible = true

func _on_demo_descanso() -> void:
	restar_pins()
	descanso.visible = true


func _on_demo_embarcadero() -> void:
	restar_pins()
	embarcadero.visible = true


func _on_demo_merendero_1() -> void:
	restar_pins()
	merendero1.visible = true


func _on_demo_merendero_2() -> void:
	restar_pins()
	merendero2.visible = true


func _on_demo_mirador() -> void:
	restar_pins()
	mirador.visible = true


func _on_demo_obras() -> void:
	restar_pins()
	obras.visible = true


func _on_demo_parking() -> void:
	restar_pins()
	parking.visible = true


func _on_demo_rescate() -> void:
	restar_pins()
	rescate.visible = true
