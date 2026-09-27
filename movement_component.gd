class_name MovementComponent extends Node

@export var body: CharacterBody3D
@export var model: Node3D
@export var speed: float = 5.0
@export var jump_strength: float = 4.0
@export var sprint_factor: float = 4.0
@export var crouch_factor: float = 2.0
var dir: Vector2
var jump: bool = false
var is_on_floor: bool
var in_air_mod: float = 0.0
## Functionally the same as a bool, only gets set to 1 or 0
var is_sprinting: int = 0
var is_crouching: bool = false


func tick(delta: float) -> void:
	is_on_floor = body.is_on_floor()
	if not is_on_floor:
		body.velocity += body.get_gravity() * delta
		in_air_mod = clamp(in_air_mod + 0.1, 0.0, speed)
	else:
		in_air_mod = 0.0
	
	if jump:
		body.velocity.y += jump_strength
		jump = false
		
	var direction = (body.transform.basis * Vector3(dir.x, 0, dir.y)).normalized()
	if direction:
		body.velocity.x = direction.x * (speed + (is_sprinting * sprint_factor) - (float(is_crouching) * crouch_factor) - in_air_mod)
		body.velocity.z = direction.z * (speed + (is_sprinting * sprint_factor) - (float(is_crouching) * crouch_factor) - in_air_mod)
	else:
		body.velocity.x = move_toward(body.velocity.x, 0, (speed + (is_sprinting * sprint_factor) - (float(is_crouching) * crouch_factor)))
		body.velocity.z = move_toward(body.velocity.z, 0, (speed + (is_sprinting * sprint_factor) - (float(is_crouching) * crouch_factor)))
	body.move_and_slide()
