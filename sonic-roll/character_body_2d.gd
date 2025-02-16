extends CharacterBody2D

enum State { NORMAL, CHARGING, ROLLING }

var current_state = State.NORMAL
var charge_time = 0.0
var roll_velocity = Vector2.ZERO
var facing_direction = 1
var roll_start_position = Vector2.ZERO
var roll_distance_traveled = 0.0

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_ROLL_SPEED = 800.0
const MIN_ROLL_SPEED = 50.0
const ROLL_FRICTION = 0.99
const MAX_CHARGE_TIME = 3.0
const MAX_ROLL_DISTANCE = 500.0

@onready var sprite = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var smoke_sprite: AnimatedSprite2D = $SmokeSprite


func _ready():
	add_charge_bar()

	if smoke_sprite:
		smoke_sprite.hide()


func update_smoke_position():
	if smoke_sprite:
		smoke_sprite.position.x = 15 if sprite.flip_h else -15
		smoke_sprite.position.y = -9
		smoke_sprite.flip_h = sprite.flip_h


func add_charge_bar():
	var progress = ProgressBar.new()
	progress.name = "ChargeBar"
	add_child(progress)
	progress.position = Vector2(-50, -50)
	progress.custom_minimum_size = Vector2(100, 10)
	progress.max_value = 100
	progress.min_value = 0
	progress.show_percentage = false
	progress.hide()


func _physics_process(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta

	match current_state:
		State.NORMAL:
			handle_normal_state(delta)
		State.CHARGING:
			handle_charge_state(delta)
		State.ROLLING:
			handle_roll_state(delta)

	move_and_slide()
	update_animation()


func handle_normal_state(delta):
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		facing_direction = sign(direction)
		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("roll") and is_on_floor():
		enter_charge_state()


func handle_charge_state(delta):
	velocity.x = 0

	if charge_time < MAX_CHARGE_TIME:
		charge_time += delta

	var charge_percent = charge_time / MAX_CHARGE_TIME
	$ChargeBar.value = charge_percent * 100

	var min_flash_speed = 5.0
	var max_flash_speed = 20.0
	var current_flash_speed = lerp(min_flash_speed, max_flash_speed, charge_percent)
	var flash_intensity = (sin(Time.get_ticks_msec() * 0.01 * current_flash_speed) + 1.0) * 0.5
	sprite.modulate = Color(
		1.0 + flash_intensity, 1.0 + flash_intensity, 1.0 + flash_intensity, 1.0
	)

	if Input.is_action_just_released("roll"):
		enter_roll_state()
	if not is_on_floor():
		exit_charge_state()


func handle_roll_state(delta):
	roll_distance_traveled += abs(velocity.x * delta)
	var should_stop = false

	if (
		(roll_distance_traveled >= MAX_ROLL_DISTANCE)
		or (Input.is_action_just_pressed("roll"))
		or (abs(velocity.x) < MIN_ROLL_SPEED)
		or (Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"))
	):
		should_stop = true

	if should_stop:
		exit_roll_state()
		return

	velocity.x = roll_velocity.x * ROLL_FRICTION

	if smoke_sprite:
		var speed_percent = abs(velocity.x) / MAX_ROLL_SPEED
		smoke_sprite.speed_scale = lerp(1.0, 5.0, speed_percent)

	var steer = Input.get_axis("left", "right") * 0.3
	velocity.x += steer * SPEED * delta


func enter_charge_state():
	current_state = State.CHARGING
	charge_time = 0.0
	animation_player.play("spin")
	$ChargeBar.show()
	$ChargeBar.value = 0

	if smoke_sprite:
		smoke_sprite.show()
		smoke_sprite.play("default")
		update_smoke_position()


func enter_roll_state():
	sprite.modulate = Color(1, 1, 1, 1)

	current_state = State.ROLLING
	roll_start_position = global_position
	roll_distance_traveled = 0.0

	var charge_percentage = clamp(charge_time / MAX_CHARGE_TIME, 0.0, 1.0)
	var roll_speed = lerp(MIN_ROLL_SPEED, MAX_ROLL_SPEED, charge_percentage)
	roll_velocity.x = roll_speed * facing_direction
	velocity = roll_velocity

	animation_player.play("spin")
	if smoke_sprite:
		smoke_sprite.show()
		smoke_sprite.speed_scale = lerp(1.0, 5.0, charge_percentage)

	$ChargeBar.hide()


func exit_charge_state():
	current_state = State.NORMAL
	charge_time = 0.0
	$ChargeBar.hide()


func exit_roll_state():
	sprite.modulate = Color(1, 1, 1, 1)

	current_state = State.NORMAL
	roll_velocity = Vector2.ZERO
	roll_distance_traveled = 0.0

	if smoke_sprite:
		smoke_sprite.speed_scale = 1.0
		smoke_sprite.hide()
		smoke_sprite.stop()


func update_animation():
	if current_state in [State.CHARGING, State.ROLLING]:
		return

	if not is_on_floor():
		if velocity.y < 0:
			animation_player.play("jump_up")
		else:
			animation_player.play("jump_down")
	else:
		if abs(velocity.x) > 0.1:
			animation_player.play("run")
		else:
			animation_player.play("idle")

	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0
