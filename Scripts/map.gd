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

func _on_demo_entrada() -> void:
	entrada.visible = true


func _on_demo_cafe() -> void:
	cafe.visible = true

func _on_demo_descanso() -> void:
	descanso.visible = true


func _on_demo_embarcadero() -> void:
	embarcadero.visible = true


func _on_demo_merendero_1() -> void:
	merendero1.visible = true


func _on_demo_merendero_2() -> void:
	merendero2.visible = true


func _on_demo_mirador() -> void:
	mirador.visible = true


func _on_demo_obras() -> void:
	obras.visible = true


func _on_demo_parking() -> void:
	parking.visible = true


func _on_demo_rescate() -> void:
	rescate.visible = true
