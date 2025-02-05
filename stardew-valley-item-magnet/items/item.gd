class_name Item extends Area2D

@export var _item_name: String
@onready var sprite: Sprite2D = $Sprite2D

var item_name: String:
	get:
		return _item_name


func get_texture() -> Texture2D:
	return sprite.texture
