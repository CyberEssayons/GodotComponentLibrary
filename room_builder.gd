@tool
class_name RoomBuilder
extends Node

@export_category("Scene Target")
@export var root_scene: Node3D
@export_category("Scene Recsources")
@export var floor_scene: PackedScene
@export var ceiling_scene: PackedScene
@export var wall_scene: PackedScene

@export_category("Room Dimensions")
@export_range(1, 10, 1, "or_greater") var room_height: int = 1
@export_range(1, 10, 1, "or_greater") var room_width: int = 5
@export_range(1, 10, 1, "or_greater") var room_depth: int = 5

@export var start_from: Vector3


var counter :int = 0

@export_tool_button("Build room") 
var build_button = build_room


func _ready() -> void:
	pass
	
func build_room() -> void:
	var room_node: Node3D = Node3D.new()
	room_node.name = "GeneratedRoom-%d" % counter
	counter += 1
	var depth_mod = 0
	var depth_mod_amt = 0
	var width_mod = 0
	var width_mod_amt = 0
	var corners = []
	
	root_scene.add_child(room_node, true)
	room_node.owner = root_scene
	var floor_node_container: Node3D = Node3D.new()
	floor_node_container.name = "FloorNodes"
	room_node.add_child(floor_node_container, true)
	floor_node_container.owner = root_scene
	for column in room_depth:
		for row in room_width:
			var tmp_floor = floor_scene.instantiate()
			floor_node_container.add_child(tmp_floor, true)
			var floor_bound_box = tmp_floor.get_child(0).get_aabb()
			#Offset the position, make sure to place the corner on the start point
			tmp_floor.global_position = start_from + Vector3(width_mod + floor_bound_box.size.x / 2, 0, depth_mod + floor_bound_box.size.z / 2)
			if width_mod_amt == 0:
				width_mod_amt = floor_bound_box.size.x
			width_mod += width_mod_amt
			if depth_mod_amt == 0:
				depth_mod_amt = floor_bound_box.size.z
			tmp_floor.owner = root_scene
			if (column == 0 and row == 0) or (column == 0 and row == room_width - 1) or (column == room_depth - 1 and row == 0) or (column == room_depth - 1 and row == room_width - 1):
				corners.append(tmp_floor)
			
		width_mod = 0
		depth_mod += depth_mod_amt
	width_mod = 0
	depth_mod = 0
	
	#now Height matters
	var height_mod = 0
	var height_mod_amt = 0
	
	#Make the walls container
	var wall_node_container: Node3D = Node3D.new()
	wall_node_container.name = "WallNodes"
	room_node.add_child(wall_node_container, true)
	wall_node_container.owner = root_scene
	for layer in room_height:
		for row in room_width:
			var left_wall = wall_scene.instantiate()
			var right_wall = wall_scene.instantiate()
			
			#Add walls to scene
			wall_node_container.add_child(left_wall, true)
			wall_node_container.add_child(right_wall, true)
			left_wall.owner = root_scene
			right_wall.owner = root_scene
			
			if height_mod_amt == 0:
				height_mod_amt = left_wall.get_child(0).get_aabb().size.y
			
			#Set wall positions
			left_wall.global_position = corners[0].global_position + Vector3(width_mod, height_mod,0 - (depth_mod_amt / 2))
			right_wall.global_position = corners[2].global_position + Vector3(width_mod, height_mod,0 + (depth_mod_amt / 2))
			
			width_mod += width_mod_amt
		for column in room_depth:
			var left_wall = wall_scene.instantiate()
			var right_wall = wall_scene.instantiate()
			
			#Add walls to scene
			wall_node_container.add_child(left_wall, true)
			wall_node_container.add_child(right_wall, true)
			left_wall.owner = root_scene
			right_wall.owner = root_scene
			
			#rotate both 90 degrees
			left_wall.rotation_degrees.y += 90
			right_wall.rotation_degrees.y += 90
			
			#Set wall positions
			left_wall.global_position = corners[0].global_position + Vector3(0 - width_mod_amt/2, height_mod, depth_mod)
			right_wall.global_position = corners[1].global_position + Vector3(width_mod_amt / 2, height_mod, depth_mod)
			
			
			depth_mod += depth_mod_amt
			
		height_mod += height_mod_amt
		depth_mod = 0
		width_mod = 0
	
	#Make the ceilings container
	var ceiling_node_container: Node3D = Node3D.new()
	ceiling_node_container.name = "CeilingNodes"
	room_node.add_child(ceiling_node_container, true)
	ceiling_node_container.owner = root_scene
	#Now build the ceilings
	for column in room_depth:
		for row in room_width:
			var tmp_ceiling = ceiling_scene.instantiate()
			ceiling_node_container.add_child(tmp_ceiling, true)
			var floor_bound_box = tmp_ceiling.get_child(0).get_aabb()
			#Offset the position, make sure to place the corner on the start point
			tmp_ceiling.global_position = start_from + Vector3(width_mod + floor_bound_box.size.x / 2, height_mod, depth_mod + floor_bound_box.size.z / 2)
			width_mod += width_mod_amt
			tmp_ceiling.owner = root_scene
		width_mod = 0
		depth_mod += depth_mod_amt
