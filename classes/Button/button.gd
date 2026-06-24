@icon("res://classes/Button/button_icon.png")
class_name Button3D
extends Node3D

signal button_pushed

const DEFAULT_DELAY = 0.15
@export var connected_nodes: Array[NodePath] = []
@export var is_locked: bool = false

func _ready() -> void:
	if connected_nodes:
		for nodepath in connected_nodes:
			if get_node(nodepath).has_method("use"):
				connect("button_pushed", get_node(nodepath).use)
				print_debug("connected %s with button %s" % [nodepath, self])
	else:
		print_debug("no connected nodes for button %s" % [self])
	$Button.call("hide" if is_locked else "show")
	$BadButton.call("show" if is_locked else "hide")
	
func use(delay: float = 0) -> void:
	if is_locked and delay == 0.0:
		print("%s was locked and pushed by player" % [self])
		return
	await get_tree().create_timer(delay).timeout
	$AnimationPlayer.play("pressed")
	$Audio.play()
	for node in connected_nodes:
		var callable = Callable(get_node(node), "use")
		callable.call(DEFAULT_DELAY)
