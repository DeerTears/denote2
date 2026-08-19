extends Node2D

@export var answer: Array[Data.PITCHES] = []

var memory: Array = []

func _ready() -> void:
	$Listener.connect("area_entered", on_area_entered)
	$Listener.connect("area_exited", on_area_exited)

func on_area_entered(area: Area2D) -> void:
	if area is PlayerSoundSource or area is SoundSource:
		area.sound_emitted.connect(on_sound_recieved)
		
func on_area_exited(area: Area2D) -> void:
	if area is PlayerSoundSource or area is SoundSource:
		area.sound_emitted.disconnect(on_sound_recieved)

func on_sound_recieved(sound_data: Sound) -> void:
	print("listener recieved %s sound data" % [sound_data])
	memory.append(sound_data)
	check_answer()

## Checks entire memory for a subset of note pitches that match the answer.
func check_answer() -> void:
	if memory.size() < answer.size():
		print("awaiting more input before checking answer")
		return
	var i: int = 0
	while i + answer.size() <= memory.size():
		# BUG: this is not iterating through the entire memory when the memory has a lot of options to choose from.
		var subset: Array = memory.slice(i, i + answer.size())
		var pitch_subset = Data.sounds_to_pitches(subset)
		if answer == pitch_subset:
			print("correct!%s | %s | full memory: %s" % [answer, pitch_subset, Data.sounds_to_named_pitches(memory)])
			memory.clear()
			return
		else:
			print("rejected: %s | %s" % [answer, pitch_subset])
			i += 1
	print("incorrect. %s | %s" % [answer, Data.sounds_to_named_pitches(memory)])
