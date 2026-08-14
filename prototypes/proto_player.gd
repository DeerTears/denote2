## A 2D prototype player.
class_name ProtoPlayer
extends CharacterBody2D

# _process() has been hijacked to run the recorder functionality.
# _physics_process() handles the player's movement and nothing else.


## How fast the player moves, in velocity units.
const SPEED := 300.0
## How fast the memory fills up, as a delta multiplier.
const MEMORY_SPEED := 0.0

## The recorded notes on the tape recorder.
var memory: Array = []
## If the recorder is currently accepting new notes.
var is_recording: bool = false

#region Recorder Functionality

func _ready() -> void:
	%RecorderArea.connect("area_entered", on_recorder_area_entered)
	%RecorderArea.connect("area_exited", on_recorder_area_exited)
	%MemoryReset.connect("pressed", set_recording_to_empty)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.is_action("proto_startstop"):
			toggle_recording()

func _process(delta: float) -> void:
	if is_recording:
		if %MemoryFull.value == %MemoryFull.max_value:
			is_recording = false
			set_recording_to_full()
		else:
			%MemoryFull.value += delta * MEMORY_SPEED

func on_recorder_area_entered(area: Area2D) -> void:
	if area is SoundSource:
		area.connect("sound_emitted", on_sound_recieved)
		print_debug("%s connected" % [area])

func on_recorder_area_exited(area: Area2D) -> void:
	if area is SoundSource:
		if area.is_connected("sound_emitted", on_sound_recieved):
			area.disconnect("sound_emitted", on_sound_recieved)
			print_debug("%s disconnected" % [area])

func on_sound_recieved(sound_data: Sound) -> void:
	if not is_recording:
		return
	var distance = global_position.distance_to(sound_data.original_location) / 480.0
	print_debug("recieved: pitch %s | length %s | octave %s | distance %s !" % [Data.NOTES.keys()[sound_data.pitch], Data.LENGTHS.keys()[sound_data.length], sound_data.octave, distance])
	add_note_to_memory(sound_data)

func add_note_to_memory(sound_data: Sound) -> void:
	memory.append(sound_data)
	var is_long = sound_data.length == Data.LENGTHS.LONG
	var new_counter: ColorRect = load("res://prototypes/proto_note_%s.tscn" % ["long" if is_long else "short"]).instantiate()
	new_counter.color = Data.get_note_color(sound_data.pitch)
	%MemoryContainer.add_child(new_counter)

func toggle_recording() -> void:
	is_recording = not is_recording
	%RecordingAnimator.play("recording" if is_recording else "idle")
	set_process(is_recording)

func set_recording_to_full() -> void:
	is_recording = false
	%RecordingAnimator.play("idle")
	%MemoryFull.value = %MemoryFull.max_value
	set_process(false)

func set_recording_to_empty() -> void:
	is_recording = false
	%RecordingAnimator.play("idle")
	%MemoryFull.value = 0.0
	set_process(false)
	for child in %MemoryContainer.get_children():
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
