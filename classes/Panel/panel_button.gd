extends Area3D
class_name KeyButton

const SCALE_FACTOR = 1.1

enum PITCHES {HIGHEST, HIGH, MEDIUM, LOW, LOWEST}

@export var note: PITCHES = PITCHES.MEDIUM

@onready var audio = $AudioStreamPlayer
@onready var mesh = $MeshInstance3D

var is_highlighted: bool = false

func play() -> void:
	audio.play()

func highlight(on: bool) -> void:
	is_highlighted = on
	mesh.scale = Vector3.ONE * (SCALE_FACTOR if on else 1.0)
