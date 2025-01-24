extends CanvasLayer

@onready var time_label = $TimeLabel

func _ready() -> void:
	# Connect to TimeManager signals
	TimeManager.time_changed.connect(_on_time_changed)
	TimeManager.speed_changed.connect(_on_speed_changed)

func _on_time_changed(hours: int, minutes: int) -> void:
	time_label.text = "%02d:%02d\n%s" % [
		hours, 
		minutes,
		TimeManager.get_speed_name()
	]

func _on_speed_changed(_new_speed: TimeManager.Speed) -> void:
	# Flash the label when speed changes
	time_label.modulate = Color.WHITE
	var tween = create_tween()
	tween.tween_property(time_label, "modulate", Color(1, 1, 1, 0.7), 0.1)
	tween.tween_property(time_label, "modulate", Color.WHITE, 0.1)

func _input(event: InputEvent) -> void:
	# Space bar toggles pause
	if event.is_action_pressed("ui_accept"):
		if TimeManager.current_speed == TimeManager.Speed.PAUSED:
			TimeManager.set_speed(TimeManager.Speed.NORMAL)
		else:
			TimeManager.set_speed(TimeManager.Speed.PAUSED)
	
	# Number keys for direct speed selection
	if event.is_pressed() and event is InputEventKey:
		match event.keycode:
			KEY_0:  # 0 for pause
				TimeManager.set_speed(TimeManager.Speed.PAUSED)
			KEY_1:  # 1 for normal speed
				TimeManager.set_speed(TimeManager.Speed.NORMAL)
			KEY_2:  # 2 for fast
				TimeManager.set_speed(TimeManager.Speed.FAST)
			KEY_3:  # 3 for ultra
				TimeManager.set_speed(TimeManager.Speed.ULTRA)
