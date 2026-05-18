extends Node

var level_times: Dictionary = {}

func save_time(level: int, time: String) -> void:
	level_times[str(level)] = time

func get_time(level: int) -> String:
	return level_times.get(str(level), "00:00:00")
