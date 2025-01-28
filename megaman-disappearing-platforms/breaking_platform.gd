extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var warning_time: float = 0.5
@export var respawn_time: float = 2.0

var is_breaking: bool = false
var is_broken: bool = false
var break_particles: GPUParticles2D
var warning_particles: GPUParticles2D
var platform_color: Color = Color(0.5, 0.2, 0.5)


func _ready() -> void:
	setup_particles()
	
func setup_particles():
	# Break particles
	break_particles = GPUParticles2D.new()
	add_child(break_particles)
	
	var break_material = ParticleProcessMaterial.new()
	break_material.direction = Vector3(0, -1, 0)
	break_material.spread = 180.0
	break_material.initial_velocity_min = 20.0
	break_material.initial_velocity_max = 40.0
	break_material.gravity = Vector3(0, 98, 0)
	break_material.scale_min = 0.5
	break_material.scale_max = 1.0
	break_material.color = platform_color
	
	# Create particle texture
	var particle_texture = GradientTexture2D.new()
	var gradient = Gradient.new()
	gradient.add_point(0.0, platform_color)
	gradient.add_point(1.0, Color(platform_color, 0.0))
	particle_texture.gradient = gradient
	particle_texture.fill_from = Vector2(0, 0)
	particle_texture.fill_to = Vector2(1, 1)
	particle_texture.width = 2
	particle_texture.height = 2
	
	break_particles.texture = particle_texture
	break_particles.process_material = break_material
	break_particles.amount = 12
	break_particles.lifetime = 0.6
	break_particles.one_shot = true
	break_particles.explosiveness = 1.0
	
	# Warning particles
	warning_particles = GPUParticles2D.new()
	add_child(warning_particles)
	
	var warning_material = ParticleProcessMaterial.new()
	warning_material.direction = Vector3(0, -1, 0)
	warning_material.spread = 45.0
	warning_material.initial_velocity_min = 5.0
	warning_material.initial_velocity_max = 10.0
	warning_material.gravity = Vector3(0, -20, 0)
	warning_material.color = Color(1, 0.3, 0.9)
	
	warning_particles.texture = particle_texture
	warning_particles.process_material = warning_material
	warning_particles.amount = 6
	warning_particles.lifetime = 0.3
	warning_particles.emitting = false


func trigger_break():
	if is_breaking or is_broken:
		return
	start_warning()
	
func start_warning():
	is_breaking = true
	sprite.modulate = Color(1, 0.5, 0.5)
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 0.5, 0.5), 0.1)
	warning_particles.emitting = true
	
	await get_tree().create_timer(warning_time).timeout
	break_platform()
	
func break_platform():
	if is_broken:
		return
		
	is_breaking = false
	is_broken = true
	warning_particles.emitting = false
	
	sprite.hide()
	collision_shape.set_deferred("disabled", true)
	
	break_particles.emitting = true
	
	await get_tree().create_timer(respawn_time).timeout
	respawn_platform()
	
func respawn_platform():
	is_broken = false
	sprite.show()
	collision_shape.set_deferred("disabled", false)
	
	sprite.modulate = Color(1,1,1,0)
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1,1,1,1), 0.2)
