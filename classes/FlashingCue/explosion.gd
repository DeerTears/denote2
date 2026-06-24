extends Area3D

const RADIUS := 3.0

var current_targets = []

@onready var new_area := Area3D.new()

#func _process(delta: float) -> void:
	#if Input.is_action_just_pressed("debug_1"):
		#_on_area_entered(new_area)
	#if Input.is_action_just_pressed("debug_2"):
		#_on_area_exited(new_area)

func _on_area_entered(area: Area3D) -> void:
	if current_targets.has(area):
		print_debug("duplicate: %s" % [area])
		return
	else:
		current_targets.append(area)
		print_debug("adding %s" % [area])

func _on_area_exited(area: Area3D) -> void:
	if current_targets.has(area):
		current_targets.remove_at(current_targets.find(area))
		print_debug("removing %s" % [area])
