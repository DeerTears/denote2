extends Area3D
class_name SubmitButton

const SCALE_FACTOR = 1.1

@onready var audio_success = $AudioSuccess
@onready var audio_fail = $AudioFail
@onready var mesh = $MeshInstance3D

func play_success(success: bool) -> void:
	if success:
		audio_success.play()
	else:
		audio_fail.play()

func highlight(on: bool) -> void:
	mesh.scale = Vector3.ONE * (SCALE_FACTOR if on else 1.0)
