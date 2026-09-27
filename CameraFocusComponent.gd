class_name CameraFocusComponent extends Node

@export var Camera: Camera3D
@export var FOV_Restrict: float = 0.5
@export var tween_time: float = 1.5
var focus_in_called: bool = false

func focus_in():
	if not focus_in_called:
		var tween = create_tween()
		tween.tween_property(Camera,"fov", (Camera.fov - FOV_Restrict),1.5)
		focus_in_called = true

func focus_out():
	if focus_in_called:
		var tween = create_tween()
		tween.tween_property(Camera,"fov", (Camera.fov + FOV_Restrict),1.5)
		focus_in_called = false
