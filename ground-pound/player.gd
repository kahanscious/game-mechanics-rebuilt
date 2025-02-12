extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var anim_player = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D

const SPEED = 300.0
const JUMP_FORCE = -400.0
const POUND_SPEED = 800

enum State { NORMAL, SPIN_START, GROUND_POUND, LANDING }

var current_state = State.NORMAL


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	match current_state:
		State.NORMAL:
			handle_normal_movement()
		State.SPIN_START:
			velocity = Vector2.ZERO
		State.GROUND_POUND:
			velocity.y = POUND_SPEED
			velocity.x = 0
			if is_on_floor():
				land_pound()
		State.LANDING:
			velocity = Vector2.ZERO

	move_and_slide()


func handle_normal_movement():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_FORCE
		anim_player.play("jump")

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor() and Input.is_action_just_pressed("jump"):
		start_spin()


func start_spin():
	current_state = State.SPIN_START
	anim_player.play("spin_pound")


func start_ground_pound():
	current_state = State.GROUND_POUND


func land_pound():
	current_state = State.LANDING
	anim_player.play("pound_land")

	if camera:
		camera.shake(8.0)


func return_to_normal():
	current_state = State.NORMAL
	anim_player.play("idle")
