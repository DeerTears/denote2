class_name Screen3D
extends Area3D

enum PITCHES {HIGHEST, HIGH, MEDIUM, LOW, LOWEST}
@export var answer: Array[PITCHES] = []

@onready var button_children: Array = [$KeyButton1, $KeyButton2, $KeyButton3, $KeyButton4, $KeyButton5]
@onready var submit_button = $SubmitButton

var memory: Array[PITCHES]

func _ready() -> void:
	for button_node in button_children:
		if button_node is KeyButton:
			button_node.input_event.connect(on_input_event.bind(button_node))
			button_node.mouse_entered.connect(on_mouse_entered.bind(button_node))
			button_node.mouse_exited.connect(on_mouse_exited.bind(button_node))
	submit_button.input_event.connect(on_submit_input_event)
	submit_button.mouse_entered.connect(on_submit_entered)
	submit_button.mouse_exited.connect(on_submit_exited)

func on_submit_input_event(_c, event: InputEvent, _ep, _n, _idx) -> void:
	if Input.is_action_just_pressed("use"):
		register_submit()

func on_submit_entered() -> void:
	submit_button.highlight(true)

func on_submit_exited() -> void:
	submit_button.highlight(false)

func on_input_event(_c, event: InputEvent, _ep, _n, _idx, button_node: Area3D) -> void:
	if Input.is_action_just_pressed("use"):
		register_press(button_node)
		button_node.play()

func on_mouse_entered(button_node: Area3D) -> void:
	print(button_node.name + " entered")
	if Input.is_action_pressed("use") and button_node.is_highlighted == false:
		if GameSettings.settings[GameSettings.ACCESS_BUTTON_CLICK] == GameSettings.INPUT_BUTTON_ON_SLIDE:
			button_node.play()
			register_press(button_node)
	button_node.highlight(true)

func on_mouse_exited(button_node: Area3D) -> void:
	button_node.highlight(false)

func register_press(button_node: Area3D) -> void:
	memory.append(button_node.note)
	print(memory)

func register_submit() -> void:
	submit_button.play_success(true if answer == memory else false)
	memory.clear()

func use() -> void:
	print("hey!")
	pass
