extends Camera3D

var camera_fov_to_radians = deg_to_rad(40) / 2.0
var aspect = 1.72
var aspect_reverse = .875

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		$Cursor.position = event.position
