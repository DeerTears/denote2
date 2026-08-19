## A helper class to hold shared constant data between scripts
class_name Data
extends Node

## One of five available pitches for use in puzzles.
## Ordered highest to lowest to make drop-downs in the Inspector clearer.
## Specific note values are assigned note-player-side, which can be superceded by accessibility settings for tone-deaf players.
enum PITCHES {HIGHEST, HIGH, MEDIUM, LOW, LOWEST}

## How long this note is, if it counts as a long note or a short note.
enum LENGTHS {SHORT, LONG}

enum VOLUMES {
	REGULAR, ## Will play the note at regular (loud) volume
	QUIET, ## Will play the note quietly, for puzzles indicating quiet notes
	SILENT ## Empty space in the pattern, does not pass any data to recorders
}

"""Other pieces of data will be added as the game is developed. Including:
	- Instrument
	- Rhythm
"""

static func sounds_to_pitches(notes: Array) -> Array[PITCHES]:
	var return_array: Array[PITCHES] = []
	for note in notes:
		if note is Sound:
			return_array.append(note.pitch)
	return return_array

static func sounds_to_named_pitches(notes: Array) -> Array[String]:
	var return_array: Array[String] = []
	var note_array: Array[PITCHES] = []
	for note in notes:
		if note is Sound:
			note_array.append(note.pitch)
	for pitch in note_array:
		return_array.append(PITCHES.keys()[pitch])
	return return_array

static func get_stream_path(sound_data: Sound) -> AudioStream:
	var stream: AudioStream = load("res://classes/Button/twingy.wav")
	match sound_data.pitch:
		Data.PITCHES.LOWEST:
			stream = load(
				"res://instrument_packs/marimba/3_e_flat-2.wav"
			)
		Data.PITCHES.LOW:
			stream = load(
				"res://instrument_packs/marimba/3_g-2.wav"
			)
		Data.PITCHES.MEDIUM:
			stream = load(
				"res://instrument_packs/marimba/4_b_flat-2.wav"
			)
		Data.PITCHES.HIGH:
			stream = load(
				"res://instrument_packs/marimba/4_c-2.wav"
			)
		Data.PITCHES.HIGHEST:
			stream = load(
				"res://instrument_packs/marimba/5_c-2.wav"
			)
	return stream

static func get_note_color(note: PITCHES) -> Color:
	var color := Color.WHITE
	match note:
		PITCHES.HIGHEST:
			color = Color("d90028")
		PITCHES.HIGH:
			color = Color("c283f2")
		PITCHES.MEDIUM:
			color = Color("ffd966")
		PITCHES.LOW:
			color = Color("007c8a")
		PITCHES.LOWEST:
			color = Color("022642")
	return color
