extends Control

@export var clock_label : Label
@export var stopwatch : Stopwatch

@export var start_button : Button

func _process(_delta) -> void:
	clock_label.text = stopwatch.format_time("{MM}:{ss}:{mmm}")

func _on_start_pressed() -> void:
	stopwatch.toggle_pause()

func _on_reset_pressed() -> void:
	stopwatch.reset()

func _on_stopwatch_pause_state_changed(stopwatch_paused: bool) -> void:
	if stopwatch_paused and stopwatch.elapsed_time > 0:
		start_button.text = "Resume"
	elif stopwatch_paused:
		start_button.text = "Start"
	else:
		start_button.text = "Pause"
