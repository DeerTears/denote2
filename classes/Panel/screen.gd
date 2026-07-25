extends Area3D

var is_active: bool = false

func _ready() -> void:
	# Clear the viewport.
	await $Mesh/SVC/SV.ready
	var viewport = $Mesh/SVC/SV
	$Mesh/SVC/SV.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	# Retrieve the texture and set it to the viewport quad.
	await RenderingServer.frame_post_draw
	$Mesh.material_override.albedo_texture = viewport.get_texture()

func use() -> void:
	print("panel used!")


func propagate_collision_point(point: Vector3) -> void:
	print(point)


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	$Mesh/SVC/SV/Puzzle._on_gui_input(event)
