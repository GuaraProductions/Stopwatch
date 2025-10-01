# Stopwatch
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Godot Engine](https://img.shields.io/badge/GODOT-%23FFFFFF.svg?style=for-the-badge&logo=godot-engine)

A utility stopwatch node for Godot 4.x

https://github.com/GuaraProductions/Stopwatch/assets/9157977/10b0d6cb-3478-4e51-bf92-4ec04cb15217

### **Godot version: 4.5**
### **Current version: 1.1.1**

This plugin encapsulates the functionality of a stopwatch, offering advanced features beyond basic time measurement. It accurately calculates the duration between activation and deactivation, providing the ability to pause the stopwatch and reset the timer as needed. Additionally, the plugin allows users to retrieve the current time in a formatted string, facilitating seamless integration with text nodes for easy display.

The video above is one of the demonstration scenes, showing what can be done with this plugin, and also a demonstration on how you can use this plugin effectively. You can find this demonstration in the "examples" folder of the project.

## How to download

Go to the download section of this github repository and download the lastest version of the plugin. 

Once downloaded, extract the contents of the zip into the ```addons``` folder. Your project directory should look something like this:

```
Your Project
    addons
        stopwatch
            ...plugin files
        ...other plugins
    ...other files
```

# Documentation

In the future, I will make a video demonstration on how to use this plugin. for now, here is the documentation that already exist in the code.

Obs.: You can access this documentation, by clicking the stopwatch logo with right-click on mouse button.

![image](https://github.com/GuaraProductions/Stopwatch/assets/9157977/0fa3a20a-8f0c-4d0a-a4ef-47c555abd8e8)

## Properties

 - float elapsed_time [padrão: 0.0] [propriedade: setter, getter]
 - bool paused [padrão: true] [propriedade: setter, getter]
 - Array[Array] checkpoints [propriedade: setter, getter]

### Export

 - String process_callback [padrão: "Idle"]
 - bool autostart [padrão: false]
 - bool pause_on_reset [padrão: false]

## Métodos

 - Array add_checkpoint()
 - Dictionary get_elapsed_time_as_dictionary()
 - String get_elapsed_time_as_formatted_string(format: String)
 - static String get_time_as_formatted_string(time_in_seconds: float, format: String)
 - static Dictionary get_time_dictionary_from_seconds(total_time_in_seconds: float)
 - void reset()
 - void toggle_pause()

## Signals

### new_checkpoint(checkpoint: float, diff_previous: float)

Emitted when a new checkpoint is added, returns the elapsed time when the checkpoint is requested. and the difference between this checkpoint and the previous one

### pause_state_changed(status: bool)

Emitted when the pause status is changed, returns if the stopwatch is currently paused or unpaused.

### time_resetted(time: float

Emitted when the stopwatch is requested to reset, returns the elapsed time before it is resetted.


## Properties description

### String process_callback [padrão: "Idle"]

Determines weather the processing of elapsed time is calculated during process(_process) or during physics frames(_physics_process) Obs.: It only takes effect when the node first enters the SceneTree.


### bool autostart [padrão: false]

Determines if the Stopwatch start after the node is ready or not.


### bool pause_on_reset [padrão: false]

Determines if the Stopwatch pauses when is resetted.


### float elapsed_time [padrão: 0.0] [propriedade: setter, getter]

amount of seconds elapsed since start.


### bool paused [padrão: true] [propriedade: setter, getter]

Determines if the execution of the stopwatch is paused or not.


### Array[Array] checkpoints [propriedade: setter, getter]

An array containing all the times a checkpoint was requested. The time is kept within an Array with two positions, the first one is the elapsed time when the checkpoint was requested, and the second position contains the difference between the current checkpoint and the previous one.


## Methods description

### Array add_checkpoint()

Add a checkpoint to the stopwatch based on its elapsed time, returns an array with the current elapsed time, and the difference between the current elapsed time and the last checkpoint. 
 
Note : this function does not take into account if the stopwatch is paused or not, so keep this in mind when invoking this function.


### Dictionary get_elapsed_time_as_dictionary()

Get the elapsed time since the stopwatch's start time and return a dictionary representing the time in hours, minutes, seconds, and milliseconds.


### String get_elapsed_time_as_formatted_string(format: String)

Formats the current elapsed time value into a string based on the specified format. the "format" is a string containing placeholders for day, hour, minute, second, and millisecond.
 
Placeholders: "{dd}" for day, "{hh}" for hour, "{MM}" for minutes, "{ss}" for seconds, "{mmm}" for milliseconds.
 
Returns:
 
String: The formatted time string based on the provided format.
 
Example:

```gdscript
  @export var stopwatch : Stopwatch
  ...
  var time: float = 1234.567 [br] [br]
  var formatted_time_str: String = stopwatch.format_time("{dd}:{hh}:{MM}:{ss}:{mmm}")[br]
  print("Formatted Time:", formatted_time_str)[br]
```
This example will output a string representing the time as "00:00:20:34:567", where:
 
- 00 days,
- 00 hours,
- 20 minutes,
- 34 seconds,
- 567 milliseconds. 
 
Note: There is a static version of this function called Stopwatch.get_time_as_formatted_string()

### String get_time_as_formatted_string(time_in_seconds: float, format: String) static

This function is a static version of the function Stopwatch.get_elapsed_time_as_formatted_string(). It works in the same way, with the only differece is that here you have to provide the parameter time_in_seconds

### Dictionary get_time_dictionary_from_seconds(total_time_in_seconds: float) static

Convert a time in seconds as a dictionary representing the time in hours, minutes, seconds, and milliseconds. 
"hours" : stores the hours 
"minutes" : stores the minutes 
"seconds" : stores the seconds 
"milliseconds" : stores the milliseconds

### void reset()

Reset the current elapsed time.

### void toggle_pause()

Toggle the stopwatch to be paused or not, depending on previous state.

## License

This project is licensed under the MIT license.
