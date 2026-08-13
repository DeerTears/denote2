## A helper class to hold shared constant data between scripts
class_name Data
extends Node

## One of five available pitches for use in puzzles.
## Ordered highest to lowest to make drop-downs in the Inspector clearer.
enum NOTES {HIGHEST, HIGH, MEDIUM, LOW, LOWEST}

## How long this note is, if it counts as a long note or a short note.
enum LENGTHS {SHORT, LONG}

"""Other pieces of data will be added as the game is developed. Including:
	- Instrument
	- Rhythm
"""
