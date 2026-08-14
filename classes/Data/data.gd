## A helper class to hold shared constant data between scripts
class_name Data
extends Node

## One of five available pitches for use in puzzles.
## Ordered highest to lowest to make drop-downs in the Inspector clearer.
## Specific note values are assigned note-player-side, which can be superceded by accessibility settings for tone-deaf players.
enum NOTES {HIGHEST, HIGH, MEDIUM, LOW, LOWEST}

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


static func get_stream_path(sound_data: Sound) -> AudioStream:
	var stream: AudioStream = load("res://classes/Button/twingy.wav")
	match sound_data.pitch:
		Data.NOTES.LOWEST:
			stream = load(
				"res://instrument_packs/marimba/3_e_flat-2.wav"
			)
		Data.NOTES.LOW:
			stream = load(
				"res://instrument_packs/marimba/3_g-2.wav"
			)
		Data.NOTES.MEDIUM:
			stream = load(
				"res://instrument_packs/marimba/4_b_flat-2.wav"
			)
		Data.NOTES.HIGH:
			stream = load(
				"res://instrument_packs/marimba/4_c-2.wav"
			)
		Data.NOTES.HIGHEST:
			stream = load(
				"res://instrument_packs/marimba/5_c-2.wav"
			)
	return stream

static func get_note_color(note: NOTES) -> Color:
	var color := Color.WHITE
	match note:
		NOTES.HIGHEST:
			color = Color("d90028")
		NOTES.HIGH:
			color = Color("c283f2")
		NOTES.MEDIUM:
			color = Color("ffd966")
		NOTES.LOW:
			color = Color("007c8a")
		NOTES.LOWEST:
			color = Color("022642")
	return color
