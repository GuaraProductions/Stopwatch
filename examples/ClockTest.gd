extends Control

@export var clock_label : Label
@export var stopwatch : Stopwatch

@export var start_button : Button

@export var checkpoint_list : VBoxContainer
@export var checkpoint_label : Label

func _ready():
	checkpoint_label.visible = false

func _process(_delta: float) -> void:
	clock_label.text = stopwatch.get_elapsed_time_as_formatted_string("{MM}:{ss}:{mmmm}")

func _on_start_pressed() -> void:
	stopwatch.toggle_pause()

func _on_reset_pressed() -> void:
	stopwatch.reset()
	checkpoint_label.visible = false
	for i in checkpoint_list.get_children():
		checkpoint_list.remove_child(i)
		i.queue_free()

func _on_stopwatch_pause_state_changed(stopwatch_paused: bool) -> void:
	if stopwatch_paused and stopwatch.elapsed_time > 0:
		start_button.text = "Resume"
	elif stopwatch_paused:
		start_button.text = "Start"
	else:
		start_button.text = "Pause"

func _on_lap_pressed():
	
	var checkpoint = stopwatch.add_checkpoint()
	
	var new_label = Label.new()
	var elapsed_time = Stopwatch.get_time_as_formatted_string(checkpoint[0],"{MM}:{ss}:{mmm}")
	var diff_time = Stopwatch.get_time_as_formatted_string(checkpoint[1],"{MM}:{ss}:{mmm}")
	new_label.text = "%s  +%s" % [elapsed_time, diff_time]
	new_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	if checkpoint_list.get_child_count() == 0:
		checkpoint_label.visible = true
		
	checkpoint_list.add_child(new_label)
