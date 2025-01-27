extends Node

enum Speed { PAUSED = 0, NORMAL = 1, FAST = 2, ULTRA = 3 }

const SPEED_MULTIPLIER = {Speed.PAUSED: 0, Speed.NORMAL: 1, Speed.FAST: 2, Speed.ULTRA: 3}

signal time_changed(hours: int, minutes: int)
signal speed_changed(new_speed: Speed)

var current_speed: Speed = Speed.NORMAL
var game_time: float = 0.0


func _process(delta: float) -> void:
	if current_speed != Speed.PAUSED:
		game_time += delta * 60 * SPEED_MULTIPLIER[current_speed]

		var hours := (game_time / 60.0) as int % 24
		var minutes := game_time as int % 60

		time_changed.emit(hours, minutes)


func set_speed(new_speed: Speed):
	current_speed = new_speed
	speed_changed.emit(new_speed)


func get_game_speed() -> String:
	return Speed.keys()[current_speed]
