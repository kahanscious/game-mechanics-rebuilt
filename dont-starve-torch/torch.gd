extends Node2D

@onready var light: PointLight2D = $PointLight2D

var base_energy: float = 1.0


func _process(delta: float) -> void:
	light.energy = base_energy + randf_range(-0.2, 0.2)
