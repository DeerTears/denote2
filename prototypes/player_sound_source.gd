## A 2D prototype version of a sound player for puzzles.
## Requires an AnimationPlayer calling emit_next_sound() on this script.
## Any source can connect to this
class_name PlayerSoundSource
extends Area2D

signal sound_emitted(current_sound: Sound)

## Sequence of sounds to play back to in-game listeners.
var sound_array: Array = [Sound.new(Data.NOTES.HIGHEST, Data.LENGTHS.SHORT, 3, Data.VOLUMES.SILENT)]

var iterator: int = 0

func iterate_through_array() -> void:
	iterator += 1
	if iterator >= sound_array.size():
		iterator = 0
		#NOTE: we /could/ add a custom delay timing here, but i think it would benefit the game to let the user choose how long each gap should be?
		#TODO: let the user add a custom silence length for a silent note?
		# or perhaps it's a type of resource that stems from the Sound resource so it can still fit within the Arrays.

func emit_next_sound() -> void:
	if sound_array.is_empty():
		return
	var current_sound = sound_array[iterator]
	iterate_through_array()
	if current_sound.volume == Data.VOLUMES.SILENT:
		$Radar.self_modulate = Color("ffffff", 0.0)
		return
	elif current_sound.volume == Data.VOLUMES.QUIET:
		$AudioStreamPlayer.volume_db = -18.0
	else:
		$AudioStreamPlayer.volume_db = 0.0
	current_sound.original_location = global_position
	sound_emitted.emit(current_sound)
	var stream: AudioStream = load("res://classes/Button/twingy.wav")
	$AudioStreamPlayer.stream = Data.get_stream_path(current_sound)
	$Radar.self_modulate = Data.get_note_color(current_sound.pitch)
	$AudioStreamPlayer.play()
	#print_debug("%s just emitted." % [current_sound])
