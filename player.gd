class_name Player extends CharacterBody3D

@onready var input_component: InputComponent = $InputComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent
@onready var pivot: Node3D = $Pivot
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
#@onready var item_interaction_component: InteractionComponent = $ItemInteractionComponent
@onready var camera_3d: Camera3D = $Pivot/Camera3D
@onready var camera_focus_component: CameraFocusComponent = $CameraFocusComponent
@onready var item_cast: RayCast3D = $Pivot/Camera3D/ItemCast
@onready var reticle_control: Control = $Reticle_Control
@onready var scope_sway_3d: ScopeSway3D = $Pivot/Camera3D/ScopeSway3D
@onready var stamina_timer: StaminaTimer = $StaminaTimer
@onready var firing_component: FiringComponent = $FiringComponent
@onready var texture_progress_bar: TextureProgressBar = $StaminaGuage/TextureProgressBar
@onready var head_bob_component: HeadBobComponent = $HeadBobComponent
@onready var foot_steps_component: RayCast3D = $FootStepsComponent
@onready var firearm_slot: Node3D = $Pivot/Camera3D/ScopeSway3D/FirearmSlot

@export var max_y_deg: float = 70.0
@export var base_sway_deg: float = 3.0
@export var max_sway_modifier: float = 5.0
@export var jump_stamina_cost: int = 1
@export var sprint_stamina_rate: int = 2
@export var walk_speed: float = 5.0

var sprint_debounce: bool = false
var aim_debounce: bool = false
var can_shoot: bool = false

var can_interact: bool = false

const base_height: float = 2.0


func _ready() -> void:
	stamina_timer.exhaustion_rate = sprint_stamina_rate
	texture_progress_bar.max_value = health_component.total_stamina
	texture_progress_bar.value = health_component.current_stamina
	movement_component.speed = walk_speed

func _physics_process(delta: float) -> void:
	if Global.player_state == Global.PLAYER_STATE.FREE_WALK:
		input_component.update()
		movement_component.dir = input_component.move_dir
		head_bob_component.input_x = input_component.move_dir.x
		sprint_debounce = sprint_debounce and input_component.sprint_active
		aim_debounce = aim_debounce and input_component.secondary_interact
		can_shoot = input_component.secondary_interact and (movement_component.is_sprinting == 0) and not movement_component.jump and not aim_debounce
		if input_component.crouch_active:
			(collision_shape_3d.shape as CapsuleShape3D).height = 1.0
			movement_component.is_crouching = true
		else:
			(collision_shape_3d.shape as CapsuleShape3D).height = base_height
			movement_component.is_crouching = false
		if input_component.jump_pressed and health_component.current_stamina >= jump_stamina_cost:
			health_component.current_stamina -= jump_stamina_cost
			movement_component.jump = input_component.jump_pressed
			aim_debounce = true
			input_component.jump_pressed = false
		else:
			movement_component.jump = false
		if input_component.sprint_active and health_component.current_stamina > 0 and not sprint_debounce:
			movement_component.is_sprinting = 1
			aim_debounce = true
			stamina_timer.start_sprint()
		else:
			movement_component.is_sprinting = 0
			stamina_timer.stop_sprint()
		if can_shoot:
			camera_focus_component.focus_in()
			reticle_control.show()
			var stamina_delta: float = (health_component.total_stamina - health_component.current_stamina) as float / health_component.total_stamina as float
			var sanity_delta: float = (health_component.total_sanity - health_component.current_sanity) as float / health_component.total_sanity as float
			scope_sway_3d.amplitude = deg_to_rad(base_sway_deg + (5 * (sanity_delta + stamina_delta)))
			if input_component.interact:
				#we shootin'
				#Here we check weapon state and determine if we even can fire
				var weapon = firearm_slot.get_child(0)
				if weapon.loaded:
					#all was well, fire away
					firing_component.fire()
					pass
				weapon.fire()
		else:
			camera_focus_component.focus_out()
			reticle_control.hide()
			scope_sway_3d.amplitude = 0.0
		movement_component.tick(delta)
		head_bob_component.tick(delta)
		
		#if item_cast.is_colliding() and item_cast.get_collider() != null:
		#	var item_collider = item_cast.get_collider().owner
			#can_interact = item_interaction_component.collide(item_collider) 
			
			#elif can_interact and input_component.interact:
				#in_hand_component.put_down(area_collider)
		#if Engine.get_physics_frames() % 5 == 0 and not item_cast.is_colliding():
			#item_interaction_component.uncollide()

func _input(event: InputEvent) -> void:
	if Global.player_state == Global.PLAYER_STATE.FREE_WALK:
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			input_component.look_update(event)
			rotate_y(deg_to_rad(input_component.look_dir.x))
			pivot.rotate_x(deg_to_rad(input_component.look_dir.y))
			pivot.rotation.x = clamp(pivot.rotation.x, -deg_to_rad(max_y_deg), deg_to_rad(max_y_deg))


func _on_stamina_timer_exhausted() -> void:
	sprint_debounce = true
	


func _on_stamina_timer_updated() -> void:
	texture_progress_bar.visible = health_component.current_stamina < health_component.total_stamina
	var ui_smoothing_tween = create_tween()
	ui_smoothing_tween.tween_property(texture_progress_bar, "value", health_component.current_stamina, stamina_timer.exhaust_time_rate if stamina_timer.is_exhausting else stamina_timer.recover_time_rate)


func _on_stamina_timer_recovered() -> void:
	texture_progress_bar.visible = false
	pass # Replace with function body.


func footfall() -> void:
	foot_steps_component.step()
	pass # Replace with function body.
