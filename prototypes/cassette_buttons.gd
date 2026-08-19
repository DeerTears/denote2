extends HBoxContainer

enum STATE {
	IDLE,
	RECORDING,
	PLAYING,
}

enum ARROW {
	RECORDING,
	PLAYING,
	RESET
}

var current_state: STATE = STATE.IDLE
var current_arrow_position: ARROW = ARROW.RECORDING

func _ready() -> void:
	$Right.pressed.connect(right_button)
	$Left.pressed.connect(left_button)
	$RecordButton.pressed.connect(change_state_to.bind(STATE.RECORDING))
	$PlayButton.pressed.connect(change_state_to.bind(STATE.PLAYING))
	$MemoryReset.pressed.connect(change_state_to.bind(STATE.IDLE))

func left_button() -> void:
	match current_arrow_position:
		ARROW.RECORDING:
			return
		ARROW.PLAYING:
			change_arrow_focus_to(ARROW.RECORDING)
		ARROW.RESET:
			change_arrow_focus_to(ARROW.PLAYING)

func right_button() -> void:
	match current_arrow_position:
		ARROW.RECORDING:
			change_arrow_focus_to(ARROW.PLAYING)
		ARROW.PLAYING:
			change_arrow_focus_to(ARROW.RESET)
		ARROW.RESET:
			return

func change_arrow_focus_to(new_position: ARROW) -> void:
	current_arrow_position = new_position
	match new_position:
		ARROW.RECORDING:
			%ModeArrow.global_position = %Target1.global_position
		ARROW.PLAYING:
			%ModeArrow.global_position = %Target2.global_position
		ARROW.RESET:
			%ModeArrow.global_position = %Target3.global_position	

func change_state_to(new_state: STATE) -> void:
	match new_state:
		STATE.IDLE:
			current_state = STATE.IDLE
			$RecordButton.button_pressed = false
			$PlayButton.button_pressed = false
		STATE.RECORDING:
			current_state = STATE.RECORDING
			$RecordButton.button_pressed = true
			$PlayButton.button_pressed = false
		STATE.PLAYING:
			current_state = STATE.PLAYING
			$RecordButton.button_pressed = false
			$PlayButton.button_pressed = true
