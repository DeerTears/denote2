## Constructor and keeper of sound data for heard elements in the game.
## This is kept as multiple properties to allow the game to disseminate types of sounds from eachother.
## This allows for some level of flexibility for how a player solves problems while navigating the environment, looking for a suitable sound.
class_name Sound
extends Resource

@export var pitch: Data.NOTES = Data.NOTES.HIGHEST
@export var length: Data.LENGTHS = Data.LENGTHS.SHORT
@export var octave: int = 3

func _init(s_pitch: Data.NOTES = Data.NOTES.HIGHEST, s_length: Data.LENGTHS = Data.LENGTHS.SHORT, s_octave: int = 3) -> void:
	pitch = s_pitch
	length = s_length
	octave = s_octave
