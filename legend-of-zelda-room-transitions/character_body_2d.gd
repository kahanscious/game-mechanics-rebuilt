class_name Character extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

const SPEED = 150.0

var can_move: bool = true


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	if direction:
		velocity = direction * SPEED
		sprite.flip_h = false if direction.x > 0 else true
	else:
		velocity = Vector2.ZERO

	move_and_slide()
