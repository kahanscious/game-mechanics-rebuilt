extends CharacterBody2D

@export var paddle_speed: int = 400
@export var is_player_one: bool = true
@export var acceleration: int = 2000
@export var deceleration: int = 2500


func _physics_process(delta: float) -> void:
	var input_direction: float = 0.0

	if is_player_one:
		input_direction = Input.get_axis("ui_up", "ui_down")
	else:
		input_direction = Input.get_axis("p2_up", "p2_down")

	if input_direction != 0:
		velocity.y = move_toward(velocity.y, input_direction * paddle_speed, acceleration * delta)
	else:
		velocity.y = move_toward(velocity.y, 0, deceleration * delta)

	move_and_slide()
