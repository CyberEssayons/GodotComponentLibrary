class_name HeadBobComponent extends Node

@export_group("Essentials")
@export var Camera: Camera3D
@export var Character: CharacterBody3D
@export_group("Settings")
@export var head_bob_amplitude: float = 0.08
@export var head_bob_frequency: float = 2.0
@export_range(0.001, 0.9, 0.001) var camera_tilt_amplitude: float = 0.01
var bob_modifier: float = 0.0
var input_x
var footfall_can_emit: bool


signal footfall

func tick(delta):
	bob_modifier += delta * Character.velocity.length() * float(Character.is_on_floor())	
	if (bob_modifier * head_bob_frequency) >= 3 * PI:
		bob_modifier = 0.0
	if Character.velocity.length() > 0:
		Camera.position = headbob(bob_modifier)
	cam_tilt(delta)

func headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * head_bob_frequency) * head_bob_amplitude
	pos.x = cos(time * head_bob_frequency / 2) * head_bob_amplitude
	
	var pi_factor = fmod((time * head_bob_frequency / 2), PI)
	var threashold = -head_bob_amplitude + 0.002
	if pos.y > threashold:
		footfall_can_emit = true
	elif pos.y < threashold and footfall_can_emit:
		footfall_can_emit = false
		footfall.emit()
	return pos


func cam_tilt(delta):
	Camera.rotation.z = lerp(Camera.rotation.z, -input_x * .01, 10 * delta)
	pass
