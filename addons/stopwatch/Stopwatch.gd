@icon("res://addons/stopwatch/assets/stopwatch.svg")
class_name Stopwatch
extends Node

## A utility node for measuring time
##
## Use this node to measure the total amount of time elapsed. You can both reset the time and also specify to start
## the time when the stopwatch enters the scene tree.

## Emitted when the stopwatch is requested to reset, returns the elapsed time before it is resetted.
signal time_resetted(time: float)
## Emitted when the pause status is changed, returns if the stopwatch is currently paused or unpaused.
signal pause_state_changed(status: bool)
## Emitted when a new checkpoint is added, returns the elapsed time when the checkpoint is requested.
## and the difference between this checkpoint and the previous one
signal new_checkpoint(checkpoint: float, diff_previous: float)

@export_enum("Idle", "Physics") var process_callback : String = "Idle" ## Determines weather the processing of elapsed time is calculated during process(_process) or during physics frames(_physics_process) Obs.: It only takes effect when the node first enters the SceneTree.
@export var autostart := false ## Determines if the Stopwatch start after the node is ready or not.
@export var pause_on_reset := false ## Determines if the Stopwatch pauses when is resetted.

var elapsed_time := 0.0 : set = set_elapsed_time_in_seconds, get = get_elapsed_time_in_seconds ## amount of seconds elapsed since start.
var paused := true : set = _set_paused, get = _get_paused ## Determines if the execution of the stopwatch is paused or not.

var checkpoints : Array[Array] : get = get_checkpoints_array, set = set_checkpoints_array ## An array containing all the times a checkpoint was requested. The time is kept within an Array with two positions, the first one is the elapsed time when the checkpoint was requested, and the second position contains the difference between the current checkpoint and the previous one.

var __process_time_in_the_physics_engine := false
var __configured := false
var __last_formatted_time : String = ""

func _ready():
	
	checkpoints = []
	paused = not autostart
	
	if process_callback == "Physics":
		__process_time_in_the_physics_engine = true

## Get the array of checkpoints.
func get_checkpoints_array() -> Array:
	return checkpoints.duplicate(true)
	
func set_checkpoints_array(array: Array) -> void:
	checkpoints = array

## Configure if the stopwatch is paused or not.
func _set_paused(is_paused: bool) -> void:
	
	paused = is_paused
	pause_state_changed.emit(paused)
	set_process(not paused and not __process_time_in_the_physics_engine)
	set_physics_process(not paused and __process_time_in_the_physics_engine)
	
## Toggle the stopwatch to be paused or not, depending on previous state.
func toggle_pause() -> void:
	paused = not paused
	 
## Checks weather the stopwatch is paused or not.
func _get_paused() -> bool:
	return paused

## Get elapsed time in seconds.
func get_elapsed_time_in_seconds() -> float:
	return elapsed_time
	
## Set elapsed time in seconds.
func set_elapsed_time_in_seconds(new_time: float) -> void:
	elapsed_time = new_time
	
## Get the elapsed time since the stopwatch's start time and return a dictionary representing the time in hours, minutes, seconds, and milliseconds.
func get_elapsed_time_as_dictionary() -> Dictionary:
	return Stopwatch.get_time_dictionary_from_seconds(elapsed_time)
	
## Add a checkpoint to the stopwatch based on its elapsed time, returns an array 
## with the current elapsed time, and the difference between the current elapsed time and the last
## checkpoint. [br] [br]
##
## [b]Note[/b] : this function does not take into account if the stopwatch is paused or not, so keep this in mind when
## invoking this function.
func add_checkpoint() -> Array:
	
	var current_elapsed_time = elapsed_time

	if checkpoints.size() == 0:
		var time_array := [current_elapsed_time,current_elapsed_time]
		
		var tmp_array = checkpoints
		tmp_array.append(time_array)
		checkpoints = tmp_array
		
		new_checkpoint.emit(time_array.duplicate())
		
		return time_array.duplicate()
		
	var previous_checkpoint = checkpoints[-1]
	
	var previous_total_time = previous_checkpoint[0]
	
	var time_array := [current_elapsed_time, current_elapsed_time - previous_total_time]
	
	var tmp_array = checkpoints
	tmp_array.append(time_array)
	checkpoints = tmp_array

	new_checkpoint.emit(time_array.duplicate())
	
	return time_array.duplicate()
	
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

## Formats the current elapsed time value into a string based on the specified format. the "format" is a string containing placeholders for day, hour, minute, second, and millisecond.[br] [br]
## Placeholders: "{dd}" for day, "{hh}" for hour, "{MM}" for minutes, "{ss}" for seconds, "{mmm}" for milliseconds.[br] [br]
## Returns:[br] [br]
##   String: The formatted time string based on the provided format.[br] [br]
## Example:[br] [code]
##   @export var stopwatch : Stopwatch
##   ...
##   var time: float = 1234.567 [br] [br]
##   var formatted_time_str: String = stopwatch.format_time("{dd}:{hh}:{MM}:{ss}:{mmm}")[br]
##   print("Formatted Time:", formatted_time_str)[br] [/code] [br]
## This example will output a string representing the time as "00:00:20:34:567", where:[br] [br]
##   - 00 days,[br]
##   - 00 hours,[br]
##   - 20 minutes,[br]
##   - 34 seconds,[br]
##   - 567 milliseconds. [br] [br]
##
## [b]Note:[/b] There is a static version of this function called [method Stopwatch.get_time_as_formatted_string]
func get_elapsed_time_as_formatted_string(format: String) -> String:
	
	if not paused or not __configured:
		__last_formatted_time = Stopwatch.get_time_as_formatted_string(elapsed_time, format)
		__configured = true
	
	return __last_formatted_time
	
## This function is a static version of the function [method Stopwatch.get_elapsed_time_as_formatted_string]. It works
## in the same way, with the only differece is that here you have to provide the parameter [param time_in_seconds]
static func get_time_as_formatted_string(time_in_seconds: float, format: String) -> String:
	var formatted_time: String = ""
	
	var total_seconds = int(time_in_seconds)
	
	@warning_ignore("integer_division")
	var hours : int = total_seconds / 3600
	
	@warning_ignore("integer_division")
	var minutes : int = (total_seconds % 3600) / 60
	
	@warning_ignore("integer_division")
	var seconds : int = total_seconds % 60
	
	@warning_ignore("integer_division")
	var days : int = total_seconds / 86400
	
	var fractional_part := time_in_seconds - int(time_in_seconds)
	
	var milliseconds := int(fractional_part * 1000)
	
	var i : int = 0
	while i < format.length():
		if format[i] == "{":
			var idx : int = format.find("}",i)
			
			if idx == -1:
				break
			
			match format[i+1]:
				"d":
					formatted_time += str(days).pad_zeros(idx-i-1)
				"h":
					formatted_time += str(hours).pad_zeros(idx-i-1)
				"m":
					formatted_time += str(int(fractional_part * pow(10,idx-i-1))).pad_zeros(idx-i-1)
				"M":
					formatted_time += str(minutes).pad_zeros(idx-i-1)
				"s":
					formatted_time += str(seconds).pad_zeros(idx-i-1)
					
			i = idx + 1
		else:
			formatted_time += format[i]
			i += 1
			
	return formatted_time

## Reset the current elapsed time.
func reset() -> void:
	var resulted_elapsed_time := elapsed_time

	elapsed_time = 0
	paused = pause_on_reset
	checkpoints.clear()
	
	time_resetted.emit(elapsed_time)
	
func _process(delta: float) -> void:
	elapsed_time += (delta * int(not __process_time_in_the_physics_engine))
	
func _physics_process(delta: float) -> void:
	elapsed_time += (delta * int(__process_time_in_the_physics_engine))
