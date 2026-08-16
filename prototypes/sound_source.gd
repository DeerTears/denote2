## A 2D prototype version of a sound player for puzzles.
## Requires an AnimationPlayer calling emit_next_sound() on this script.
## Any source can connect to this
class_name SoundSource
extends Area2D

signal sound_emitted(current_sound: Sound)

## Sequence of sounds to play as a source.
@export var sound_array: Array[Sound] = []
@export var init_delay: float = 2.0

var iterator: int = 0

func _ready() -> void:
	await get_tree().create_timer(init_delay).timeout
	# TODO: separate this call to AnimationPlayer out so the sound source is generalizable
	# we want both the world and the player to use this so we don't need to repeat ourselves
	# /then/ ask the world sources to have animationplayers on the soundsources (soundemitters?)
	if get_node_or_null("AnimationPlayer"):
		$AnimationPlayer.play("radar")

func iterate_through_array() -> void:
	iterator += 1
	if iterator >= sound_array.size():
		iterator = 0
		#NOTE: we /could/ add a custom delay timing here, but i think it would benefit the game to let the user choose how long each gap should be?
		#TODO: let the player add a custom silence length for a silent note?
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
		$AudioStreamPlayer2D.volume_db = -18.0
	else:
		$AudioStreamPlayer2D.volume_db = 0.0
	current_sound.original_location = global_position
	sound_emitted.emit(current_sound)
	var stream: AudioStream = load("res://classes/Button/twingy.wav")
	$AudioStreamPlayer2D.stream = Data.get_stream_path(current_sound)
	$Radar.self_modulate = Data.get_note_color(current_sound.pitch)
	$AudioStreamPlayer2D.play()
	#print_debug("%s just emitted." % [current_sound])
