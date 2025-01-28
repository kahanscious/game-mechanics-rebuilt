extends Camera2D

@export var smoothing_enabled: bool = true
@export var smoothing_speed: float = 5.0

const ROOM_WIDTH: int = 320
const ROOM_HEIGHT: int = 240
const TRANSITION_DURATION: float = 1.0

var current_room: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var is_transitioning: bool = false
var player: Character = null
var transition_tween: Tween


func _ready() -> void:
	start_room_transition(Vector2(0, -1))
	player = get_tree().get_first_node_in_group("player")


func start_room_transition(room_coord: Vector2):
	if is_transitioning:
		return

	current_room = room_coord
	position_smoothing_enabled = false

	limit_bottom = 100000000
	limit_left = -100000000
	limit_right = 100000000
	limit_top = -100000000

	if player:
		player.can_move = false
		player.velocity = Vector2.ZERO

	is_transitioning = true

	target_position = Vector2(
		(current_room.x * ROOM_WIDTH) + (ROOM_WIDTH / 2),
		(current_room.y * ROOM_HEIGHT) + (ROOM_HEIGHT / 2)
	)

	if transition_tween:
		transition_tween.kill()

	transition_tween = create_tween()
	transition_tween.set_trans(Tween.TRANS_SINE)
	transition_tween.set_ease(Tween.EASE_IN_OUT)

	transition_tween.tween_property(self, "global_position", target_position, TRANSITION_DURATION)
	transition_tween.tween_callback(finish_transition)


func finish_transition():
	position_smoothing_enabled = smoothing_enabled
	position_smoothing_speed = smoothing_speed

	limit_bottom = limit_top + ROOM_HEIGHT
	limit_left = current_room.x * ROOM_WIDTH
	limit_right = limit_left + ROOM_WIDTH
	limit_top = current_room.y * ROOM_HEIGHT

	is_transitioning = false
	if player:
		player.can_move = true
