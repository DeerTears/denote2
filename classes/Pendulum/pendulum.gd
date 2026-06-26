extends Node3D

@export var animation_name := ""

func _ready() -> void:
	$AnimationPlayer.play(animation_name)
	$PendulumBody/AudioStreamPlayer3D.pitch_scale = randf_range(0.7, 1.0)
