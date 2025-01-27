extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * TimeManager.SPEED_MULTIPLIER[TimeManager.current_speed]
		animation_player.play("walk")
		animation_player.speed_scale = TimeManager.SPEED_MULTIPLIER[TimeManager.current_speed]
		sprite.flip_h = direction < 0
	else:
		velocity.x = 0
		animation_player.play("idle")
		animation_player.speed_scale = TimeManager.SPEED_MULTIPLIER[TimeManager.current_speed]

	move_and_slide()
