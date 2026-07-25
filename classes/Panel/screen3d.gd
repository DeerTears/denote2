extends Area3D

"""
NOTE: Do not use is_active to grab focus, let the player choose this node as its
active screen. Null means the player regains control of their own camera.

Make sure to make ray_pickable = false on this Area3D while this screen is active, else it will eat the button inputs.
"""

@onready var button_children: Array = [$KeyButton1, $KeyButton2, $KeyButton3, $KeyButton4, $KeyButton5]

func _ready() -> void:
	for button_node in button_children:
		if button_node is Area3D:
			button_node.input_event
			print(button_node)
			button_node.input_event.connect(on_input_event.bind(button_node))

func on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int, button_node: Node) -> void:
	if Input.is_action_just_pressed("use"):
		button_node.play()

func use() -> void:
	print("hey!")
	pass
