@icon("res://addons/stopwatch/assets/stopwatch.png")
class_name Stopwatch
extends Node

## A utility node for counting time
##
## Use this node to measure the total amount of time elapsed. You can both reset the time and also specify to start
## the time when the stopwatch enters the scene tree

## Emitted when the stopwatch is requested to reset, returns the elapsed time before it is resetted
signal time_resetted(time: float)
## Emitted when the pause status is changed, returns if the stopwatch is currently paused or unpaused
signal pause_state_changed(status: bool)

@export_enum("Idle", "Physics") var process_callback : String = "Idle" ## Determines weather the processing of elapsed time is calculated during process(_process) or during physics frames(_physics_process) Obs.: It only takes effect when the node first enters the SceneTree
@export var autostart := false ## Determines if the Stopwatch start after the node is ready or not
@export var pause_on_reset := false ## Determines if the Stopwatch pauses when is resetted

var elapsed_time := 0.0 : set = set_elapsed_time_in_seconds, get = get_elapsed_time_in_seconds ## amount of seconds elapsed since start
var paused := true : set = _set_paused, get = _get_paused ## pauses the execution of the stopwatch if true

var __process_time_in_the_physics_engine := false

func _ready():
	paused = not autostart
	
	if process_callback == "Physics":
		__process_time_in_the_physics_engine = true

## Configure if the stopwatch is paused or not
func _set_paused(is_paused: bool) -> void:
	paused = is_paused
	pause_state_changed.emit(paused)
	set_process(not paused and not __process_time_in_the_physics_engine)
	set_physics_process(not paused and __process_time_in_the_physics_engine)
	
## Toggle the stopwatch to be paused or not, depending on previous state
func toggle_pause() -> void:
	paused = not paused
	 
## Checks weather the stopwatch is paused or not
func _get_paused() -> bool:
	return paused

## Get elapsed time in seconds
func get_elapsed_time_in_seconds() -> float:
	return elapsed_time
	
## Set elapsed time in seconds
func set_elapsed_time_in_seconds(new_time: float) -> void:
	elapsed_time = new_time
	
## Get the elapsed time since the stopwatch's start time and return a dictionary representing the time in hours, minutes, seconds, and milliseconds.
func get_elapsed_time_as_dictionary() -> Dictionary:
	return Stopwatch.get_time_dictionary_from_seconds(elapsed_time)
	
## Convert a time in seconds as a dictionary representing the time in hours, minutes, seconds, and milliseconds. [br]
## "hours" : stores the hours [br]
## "minutes" : stores the minutes [br]
## "seconds" : stores the seconds [br]
## "milliseconds" : stores the milliseconds 
static func get_time_dictionary_from_seconds(total_time_in_seconds: float) -> Dictionary:
	var total_seconds = int(total_time_in_seconds)
	
	@warning_ignore("integer_division")
	var hours : int = total_seconds / 3600
	
	@warning_ignore("integer_division")
	var minutes : int = (total_seconds % 3600) / 60
	
	@warning_ignore("integer_division")
	var seconds : int = total_seconds % 60
	
	@warning_ignore("integer_division")
	var days : int = total_seconds / 86400
	
	var fractional_part := total_time_in_seconds - int(total_time_in_seconds)
	
	var milliseconds := int(fractional_part * 1000)
	
	return {
		"hours" : hours,
		"minutes" : minutes,
		"seconds" : seconds,
		"milliseconds" : milliseconds
	}

## Formats the given time value into a string based on the specified format. the "format" is a string containing placeholders for day, hour, minute, second, and millisecond.[br] [br]
## Placeholders: "{dd}" for day, "{hh}" for hour, "{MM}" for minutes, "{ss}" for seconds, "{mmm}" for milliseconds.[br] [br]
## Returns:[br] [br]
##   String: The formatted time string based on the provided format.[br] [br]
## Example:[br] [code]
##   var time: float = 1234.567 [br] [br]
##   var formatted_time_str: String = format_time("{dd}:{hh}:{MM}:{ss}:{mmm}")[br]
##   print("Formatted Time:", formatted_time_str)[br] [/code] [br]
## This example will output a string representing the time as "00:00:20:34:567", where:[br] [br]
##   - 00 days,[br]
##   - 00 hours,[br]
##   - 20 minutes,[br]
##   - 34 seconds,[br]
##   - 567 milliseconds.
func format_time(format: String) -> String:
	var formatted_time: String = ""
	
	var total_seconds = int(elapsed_time)
	
	@warning_ignore("integer_division")
	var hours : int = total_seconds / 3600
	
	@warning_ignore("integer_division")
	var minutes : int = (total_seconds % 3600) / 60
	
	@warning_ignore("integer_division")
	var seconds : int = total_seconds % 60
	
	@warning_ignore("integer_division")
	var days : int = total_seconds / 86400
	
	var fractional_part := elapsed_time - int(elapsed_time)
	
	var milliseconds := int(fractional_part * 1000)
	
	if format.contains("{dd}"):
		format = format.replace("{dd}", str(days).pad_zeros(2))
	if format.contains("{hh}"):
		format = format.replace("hh", str(hours).pad_zeros(2))
	if format.contains("{MM}"):
		format = format.replace("{MM}", str(minutes).pad_zeros(2))
	if format.contains("{ss}"):
		format = format.replace("{ss}", str(seconds).pad_zeros(2))
	if format.contains("{mmm}"):
		format = format.replace("{mmm}", str(milliseconds).pad_zeros(3))

	formatted_time = format
	
	return formatted_time
	
## Reset the current elapsed time
func reset() -> void:
	var resulted_elapsed_time := elapsed_time

	elapsed_time = 0
	paused = pause_on_reset
	
	time_resetted.emit(elapsed_time)	
	
func _process(delta: float) -> void:
	elapsed_time += (delta * int(not __process_time_in_the_physics_engine))
	
func _physics_process(delta: float) -> void:
	elapsed_time += (delta * int(__process_time_in_the_physics_engine))
