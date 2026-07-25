extends Area3D

@onready var audio = $AudioStreamPlayer

func play() -> void:
	audio.play()
