extends Node3D

@export var start_closed: bool = true
@export var is_locked: bool = false
# TODO: implement for running into doors puzzles
@export var is_autoclosing: bool = false
@export_range(0.1, 30.0, 0.1) var autoclose_delay: float = 1.0
#@export var swing_right: bool = false # TODO: make right_facing set of swing door animations

var is_open: bool = false

func _ready() -> void:
	print(position, global_position)
	if start_closed:
		is_open = false
	else:
		is_open = true

func use(delay: float = 0.0) -> void:
	is_open = not is_open
	await get_tree().create_timer(delay).timeout
	if is_locked and delay == 0.0:
		animate_locked()
		return
	if is_autoclosing:
		open()
		await get_tree().create_timer(delay).timeout # WARNING: this callback cannot be interrupted, consider using some other kind of state machine to handle this instead.
		close()
		return
	$AnimationPlayer.play("open_left" if is_open else "close_left")

func animate_locked() -> void:
	print_debug("%s is locked" % [self])
	#var tween = get_tree().create_tween()
	#$MeshInstance3D.scale = Vector3.ONE * 1.125
	#tween.tween_property($MeshInstance3D,"scale", Vector3.ONE, 0.25).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

func open() -> void:
	$AnimationPlayer.play("open_left")
	is_open = true

func close() -> void:
	$AnimationPlayer.play("close_left")
	is_open = false
