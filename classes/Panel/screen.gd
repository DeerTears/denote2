extends Area3D

var is_active: bool = false


# The size of the quad mesh itself.
var quad_mesh_size
# Used for checking if the mouse is inside the Area
var is_mouse_inside = false
# Used for checking if the mouse was pressed inside the Area
var is_mouse_held = false
# The last non-empty mouse position. Used when dragging outside of the box.
var last_mouse_pos3D = null
# The last processed input touch/mouse event. To calculate relative movement.
var last_mouse_pos2D = null


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
	$Mesh/SVC/SV/Node2D/Puzzle._on_gui_input(event)
