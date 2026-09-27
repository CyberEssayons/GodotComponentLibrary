class_name FiringComponent extends Node3D

@export var WeaponContainer: Node3D
enum WEAPON_TYPE{PISTOL, RIFLE, SHOTGUN}

var weapon_type: WEAPON_TYPE 
var damage_per_shot: int

var max_range: int = 1000

var shotgun_shot_num: int
var shotgun_shot_spread: float


func fire() -> void:
	match weapon_type:
		WEAPON_TYPE.PISTOL:
			fire_single_shot()
		WEAPON_TYPE.SHOTGUN:
			fire_multi_shot(shotgun_shot_num, shotgun_shot_spread)

func fire_single_shot() -> void:
	var space_state = get_world_3d().direct_space_state
	
	var start = WeaponContainer.global_transform.origin
	var end = start + WeaponContainer.global_transform.basis.z * (-1 * max_range)
	
	var query = PhysicsRayQueryParameters3D.create(start, end)
	var collision = space_state.intersect_ray(query)
	if collision:
		#print(collision["collider"].get_meta("Ground"))
		print(collision)
	pass
	
func fire_multi_shot(shot_num: int, spread_deg: float) -> void:
	pass
