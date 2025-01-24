extends Node
# TimeManager.gd - Autoload singleton for time control

enum Speed {
	PAUSED = 0,
	NORMAL = 1,
	FAST = 2,
	ULTRA = 3
}

const SPEED_MULTIPLIERS = {
	Speed.PAUSED: 0,
	Speed.NORMAL: 1,
	Speed.FAST: 3,
	Speed.ULTRA: 5
}

var current_speed: Speed = Speed.NORMAL
var game_time: float = 0  # Time in minutes

signal time_changed(hours: int, minutes: int)
signal speed_changed(new_speed: Speed)

func _process(delta: float) -> void:
	if current_speed != Speed.PAUSED:
		# Update game time (1 real second = 1 game minute at normal speed)
		game_time += delta * 60 * SPEED_MULTIPLIERS[current_speed]
		
		var hours := (game_time / 60.0) as int % 24
		var minutes := game_time as int % 60
		
		time_changed.emit(hours, minutes)

func set_speed(new_speed: Speed) -> void:
	current_speed = new_speed
	speed_changed.emit(new_speed)

func get_speed_name() -> String:
	return Speed.keys()[current_speed]
