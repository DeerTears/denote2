extends AudioStreamPlayer

@onready var opening_song = preload("res://classes/Music/limbic_bits_prophet5_sequential_shortened.ogg")

func _ready() -> void:
	bus = "Music"
	stream = opening_song
	play()
