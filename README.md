# Stopwatch
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Godot Engine](https://img.shields.io/badge/GODOT-%23FFFFFF.svg?style=for-the-badge&logo=godot-engine)

A utility stopwatch node for Godot 4.x

https://github.com/GuaraProductions/Stopwatch/assets/9157977/5346bca8-c487-4296-a03a-4bb875a9efc3

**Current version: 4.2**

This plugin encapsulates the functionality of a stopwatch, offering advanced features beyond basic time measurement. It accurately calculates the duration between activation and deactivation, providing the ability to pause the stopwatch and reset the timer as needed. Additionally, the plugin allows users to retrieve the current time in a formatted string, facilitating seamless integration with text nodes for easy display.

The video above is one of the demonstration scenes, showing what can be done with this plugin, and also a demonstration on how you can use this plugin effectively. You can find this demonstration in the "examples" folder of the project.

## How to download

Go to the download section of this github repository and download the lastest version of the plugin. 

Once downloaded, extract the contents of the zip into the ```addons``` folder. Your project directory should look something like this:

```
Your Project
    addons
        stopwatch
            ...stopwatch plugin files
        ...other plugins
    ...other files
```

# Documentation

In the future, I will make a video demonstration on how to use this plugin.

## Properties
 - String process_callback [padrão: "Idle"]
 - bool autostart [padrão: false]
 - bool pause_on_reset [padrão: false]
 - float elapsed_time [padrão: 0.0] [propriedade: setter, getter]
 - bool paused [padrão: true] [propriedade: setter, getter]

## Methods
 - String format_time(format: String)
 - Dictionary get_elapsed_time_as_dictionary()
 - static Dictionary get_time_dictionary_from_seconds(total_time_in_seconds: float)
 - void reset()
 - void toggle_pause()

## Signals

### pause_state_changed(status: bool)
    Emitted when the pause status is changed, returns if the stopwatch is currently paused or unpaused

### time_resetted(time: float)
    Emitted when the stopwatch is requested to reset, returns the elapsed time before it is resetted


## Properties description

### String process_callback [padrão: "Idle"]

Determines weather the processing of elapsed time is calculated during process(_process) or during physics frames(_physics_process) Obs.: It only takes effect when the node first enters the SceneTree


### bool autostart [padrão: false]

Determines if the Stopwatch start after the node is ready or not


### bool pause_on_reset [padrão: false]

Determines if the Stopwatch pauses when is resetted


### float elapsed_time [padrão: 0.0] [propriedade: setter, getter]

amount of seconds elapsed since start


### bool paused [padrão: true] [propriedade: setter, getter]

pauses the execution of the stopwatch if true


## Methods description

### String format_time(format: String)

Formats the given time value into a string based on the specified format. the "format" is a string containing placeholders for day, hour, minute, second, and millisecond.
 
Placeholders: "dd" for day, "hh" for hour, "MM" for minutes, "ss" for seconds, "mm" for milliseconds.
 
Returns:
 
String: The formatted time string based on the provided format.
 
Example:
 
  var time: float = 1234.567 [br] [br]
  var formatted_time_str: String = format_time("dd:hh:MM:ss:mm")[br]
  print("Formatted Time:", formatted_time_str)[br]  
This example will output a string representing the time as "00:00:20:34:567", where:
 
- 00 days,
- 00 hours,
- 20 minutes,
- 34 seconds,
- 567 milliseconds.


### Dictionary get_elapsed_time_as_dictionary()

Get the elapsed time since the stopwatch's start time and return a dictionary representing the time in hours, minutes, seconds, and milliseconds.


### Dictionary get_time_dictionary_from_seconds(total_time_in_seconds: float) static

Convert a time in seconds as a dictionary representing the time in hours, minutes, seconds, and milliseconds. 
"hours" : stores the hours 
"minutes" : stores the minutes 
"seconds" : stores the seconds 
"milliseconds" : stores the milliseconds


### void reset()

Reset the current elapsed time


### void toggle_pause()

Toggle the stopwatch to be paused or not, depending on previous state

## License

This project is licensed under the MIT license.
