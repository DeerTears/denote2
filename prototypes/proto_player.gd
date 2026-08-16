## A 2D prototype player.
class_name ProtoPlayer
extends CharacterBody2D

## How fast the player moves, in velocity units.
const SPEED := 300.0
## How fast the memory fills up, as a delta multiplier.
const MEMORY_SPEED := 0.0

## The recorded notes on the tape recorder, pulling from the custom Sound class.
var memory: Array = []

## Which state the player is currently exhibiting.
enum STATE {
	IDLE, ## The player is not recording or playing.
	RECORDING, ## The player is recording, inputs are added to memory.
	PLAYING ## The player is playing, new inputs are ignored, world listeners are taking this input now.
}

var current_state: STATE = STATE.IDLE

## UI for the player to see what they have captured on tape.
@onready var memory_container_node = %MemoryContainer

## State machine function, sole function is to change state and call related functions.
func change_state_to(new_state: STATE) -> void:
	
	match new_state:
		STATE.IDLE:
			current_state = STATE.IDLE
			%RecordingAnimator.play("stopped")
			%PlayerSoundSource/AnimationPlayer.play("stopped")
		STATE.RECORDING:
			current_state = STATE.RECORDING
			%RecordingAnimator.play("playing")
		STATE.PLAYING:
			current_state = STATE.PLAYING
			%RecordingAnimator.play("stopped")
			%PlayerSoundSource.iterator = 0 # set the sequence to play at the start
			%PlayerSoundSource/AnimationPlayer.play("playing") # start playing the sequence via an animation player loop

# TODO: changeout these two bools to a state machine
var is_playing: bool = false

#region Recorder Functionality

func _ready() -> void:
	%RecorderArea.connect("area_entered", on_recorder_area_entered)
	%RecorderArea.connect("area_exited", on_recorder_area_exited)
	%MemoryReset.connect("pressed", reset_memory)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action("proto_startstop_recording"):
			match current_state:
				STATE.RECORDING:
					change_state_to(STATE.IDLE)
				STATE.IDLE:
					change_state_to(STATE.RECORDING)
				STATE.PLAYING:
					change_state_to(STATE.RECORDING)
		if event.is_action("proto_startstop_playback"):
			match current_state:
				STATE.RECORDING:
					change_state_to(STATE.PLAYING)
				STATE.IDLE:
					change_state_to(STATE.PLAYING)
				STATE.PLAYING:
					change_state_to(STATE.IDLE)

#region Entering/Leaving Other Sound Sources
func on_recorder_area_entered(area: Area2D) -> void:
	if area is SoundSource:
		area.connect("sound_emitted", on_sound_recieved)
		#print_debug("%s connected" % [area])

func on_recorder_area_exited(area: Area2D) -> void:
	if area is SoundSource:
		if area.is_connected("sound_emitted", on_sound_recieved):
			area.disconnect("sound_emitted", on_sound_recieved)
			#print_debug("%s disconnected" % [area])
#endregion

#region Interpreting Sound Data Inputs

func on_sound_recieved(sound_data: Sound) -> void:
	if current_state == STATE.RECORDING:
		var distance = global_position.distance_to(sound_data.original_location) / 480.0
		print_debug("recieved: pitch %s | length %s | octave %s | distance %s !" % [Data.NOTES.keys()[sound_data.pitch], Data.LENGTHS.keys()[sound_data.length], sound_data.octave, distance])
		add_note_to_memory(sound_data)

func add_note_to_memory(sound_data: Sound) -> void:
	memory.append(sound_data)
	var is_long = sound_data.length == Data.LENGTHS.LONG
	var new_counter: ColorRect = load("res://prototypes/proto_note_%s.tscn" % ["long" if is_long else "short"]).instantiate()
	new_counter.color = Data.get_note_color(sound_data.pitch)
	memory_container_node.add_child(new_counter)
	%PlayerSoundSource.sound_array = [Sound.new(Data.NOTES.HIGHEST, Data.LENGTHS.SHORT, 3, Data.VOLUMES.SILENT)] if memory.is_empty() else memory

func reset_memory() -> void:
	change_state_to(STATE.IDLE)
	# BUG: gets priority to avoid out of bounds array race condition OOF
	# BUG: this is maybe where the array gets confused?
	memory.clear()
	%PlayerSoundSource.sound_array = [Sound.new(Data.NOTES.HIGHEST, Data.LENGTHS.SHORT, 3, Data.VOLUMES.SILENT)]
	# Handling UI
	for child in memory_container_node.get_children():
		child.queue_free()
#endregion

#region Character Movement
func _physics_process(_delta: float) -> void:
	var x_direction := Input.get_axis("proto_left", "proto_right")
	var y_direction := Input.get_axis("proto_up", "proto_down")
	if x_direction:
		velocity.x = x_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if y_direction:
		velocity.y = y_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
#endregion

#region Debug

func _process(_delta: float) -> void:
	debug_text_display()

func debug_text_display() -> void:
	var new_string: String = ""
	new_string += "%s\n" % [STATE.keys()[current_state]]
	for unit in $PlayerSoundSource.sound_array:
		new_string += "%s\n" % [Data.NOTES.keys()[unit.pitch]]
	$CanvasLayer/Debug/Label.text = new_string
#endregion
