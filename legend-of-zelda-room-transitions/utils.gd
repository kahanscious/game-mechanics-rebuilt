extends Node

enum Direction { UP, DOWN, LEFT, RIGHT }


func direction_to_vector(dir: Direction) -> Vector2:
	match dir:
		Direction.UP:
			return Vector2(0, -1)
		Direction.DOWN:
			return Vector2(0, 1)
		Direction.LEFT:
			return Vector2(-1, 0)
		Direction.RIGHT:
			return Vector2(1, 0)
		_:
			return Vector2.ZERO
