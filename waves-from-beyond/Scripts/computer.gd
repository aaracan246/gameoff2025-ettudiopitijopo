extends Node3D

var sensitivity := 0.002
var max_yaw := deg_to_rad(15)    # límite horizontal
var max_pitch := deg_to_rad(10)  # límite vertical
var smoothing := 8.0             # velocidad de suavizado

var target_yaw := 0.0
var target_pitch := 0.0
var current_yaw := 0.0
var current_pitch := 0.0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		target_yaw -= event.relative.x * sensitivity
		target_pitch -= event.relative.y * sensitivity

		target_yaw = clamp(target_yaw, -max_yaw, max_yaw)
		target_pitch = clamp(target_pitch, -max_pitch, max_pitch)

func _process(delta):
	# Interpolación suave (lerp)
	current_yaw = lerp(current_yaw, target_yaw, delta * smoothing)
	current_pitch = lerp(current_pitch, target_pitch, delta * smoothing)

	rotation_degrees = Vector3(rad_to_deg(current_pitch), rad_to_deg(current_yaw), 0)
