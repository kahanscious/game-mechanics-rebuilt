# assets - https://pixel-poem.itch.io/dungeon-assetpuck

extends Node2D

@onready var door_animations: AnimationPlayer = $Environment/Door/AnimationPlayer
@onready var door_blocker: StaticBody2D = $Environment/Door/StaticBody2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	door_animations.play("open")
	await door_animations.animation_finished
