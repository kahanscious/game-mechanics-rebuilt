extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const SPEED = 150.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME: float = 0.15

var coyote_timer: float = 0.0
var has_coyote_jump: bool = false


func _physics_process(delta: float) -> void:
	if is_on_floor():
		has_coyote_jump = true
		coyote_timer = COYOTE_TIME
	elif has_coyote_jump:
		coyote_timer -= delta
		if coyote_timer <= 0:
			has_coyote_jump = false

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and (is_on_floor() or has_coyote_jump):
		velocity.y = JUMP_VELOCITY
		has_coyote_jump = false

	var direction := Input.get_axis("left", "right")
	if direction:
		animation_player.play("move")
		velocity.x = direction * SPEED
		sprite.flip_h = true if direction < 0 else false
	else:
		animation_player.play("idle")
		velocity.x = 0

	move_and_slide()
	
	if is_on_floor():
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			
			if collider is StaticBody2D and collider.has_method("trigger_break"):
				collider.trigger_break()
		
		
		
		
		
		
		
		
		
		
		
