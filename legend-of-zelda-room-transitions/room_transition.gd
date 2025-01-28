extends Area2D

@export var direction: Utils.Direction

var active: bool = true


func _on_body_entered(body: Node2D) -> void:
	if not active or not body is Character:
		return

	var camera: Camera2D = get_tree().get_first_node_in_group("camera")
	if camera and not camera.is_transitioning:
		active = false
		var dir_vector = Utils.direction_to_vector(direction)
		var new_room = camera.current_room + dir_vector
		camera.start_room_transition(new_room)


func _on_body_exited(body: Node2D) -> void:
	if body is Character:
		active = true
