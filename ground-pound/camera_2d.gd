extends Camera2D

var shake_amount = 0
var default_offset = offset
var pos_x
var pos_y
var rng = RandomNumberGenerator.new()


func _ready() -> void:
	set_process(false)
	rng.randomize()


func _process(delta: float) -> void:
	if shake_amount > 0:
		pos_x = rng.randf_range(-1.0, 1.0) * shake_amount * 2.0
		pos_y = rng.randf_range(-1.0, 1.0) * shake_amount

		offset = Vector2(pos_x, pos_y)

		shake_amount = lerp(shake_amount, 0.0, 0.3)

		if shake_amount <= 0.1:
			shake_amount = 0
			offset = default_offset
			set_process(false)


func shake(amount: float):
	shake_amount = amount
	set_process(true)
