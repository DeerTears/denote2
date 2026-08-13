## A 2D prototype version of a sound player for puzzles.
## Requires an AnimationPlayer calling emit_next_sound() on this script.
## Any source can connect to this
class_name SoundSource
extends Area2D

signal sound_emitted(current_sound: Sound)

## Sequence of sounds to play as a source.
@export var sound_array: Array[Sound] = []
@export var init_delay: float = 2.0
@export var is_from_player: bool = false

var iterator: int = 0

func _ready() -> void:
	await get_tree().create_timer(init_delay).timeout
	$AnimationPlayer.play("radar")

func iterate_through_array() -> void:
	iterator += 1
	if iterator >= sound_array.size():
		iterator = 0
		#TODO: add_repeat_delay_to_iteration?

func emit_next_sound() -> void:
	if sound_array.is_empty():
		return
	var current_sound = sound_array[iterator]
	iterate_through_array()
	sound_emitted.emit(current_sound)
	#print_debug("%s just emitted." % [current_sound])
