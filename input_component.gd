class_name InputComponent extends Node

@export var allow_jump: bool = true
@export var look_sensitivity: float = 0.5
var move_dir: Vector2
var mouse_dir: Vector2
var look_dir: Vector2
var jump_pressed: bool = false
var action_q: bool = false
var action_e: bool = false
var esc_pressed: bool = false
var interact: bool = false
var secondary_interact: bool = false
var sprint_active: bool = false
var crouch_active: bool = false

var ignore_mouse: bool = false

func update() -> void:
	move_dir = Input.get_vector("left", "right", "up", "down")
	if allow_jump:
		jump_pressed = Input.is_action_just_pressed("jump")
		
	action_q = Input.is_action_pressed("q")
	action_e = Input.is_action_pressed("e")
	esc_pressed = Input.is_action_just_pressed("esc")
	interact = Input.is_action_just_pressed("interact")
	secondary_interact = Input.is_action_pressed("secondary interact")
	sprint_active = Input.is_action_pressed("sprint")
	crouch_active = Input.is_action_pressed("crouch")
	
	mouse_dir = get_viewport().get_mouse_position()
	
func look_update(event: InputEventMouseMotion) -> void:
	if (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		look_dir.x = -event.relative.x * look_sensitivity
		look_dir.y = -event.relative.y * look_sensitivity
