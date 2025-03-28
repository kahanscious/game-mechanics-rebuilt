class_name Ball extends CharacterBody2D

var speed: int = 400
var direction: Vector2 = Vector2(1, 0).normalized()


func _ready() -> void:
	direction = direction.rotated(randf_range(-PI / 4, PI / 4))
	reset_ball()


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)

	if collision:
		handle_collision(collision)


func handle_collision(collision) -> void:
	var normal = collision.get_normal()
	direction = direction.bounce(normal)


func reset_ball() -> void:
	global_position = Vector2(640, 360)
	speed = 400

	direction.x = [-1, 1][randi() % 2]
	direction.y = randf_range(-0.3, 0.3)
	direction = direction.normalized()
