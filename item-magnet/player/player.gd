class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collection_zone: Area2D = $CollectionZone
@onready var ui: InventoryUI = $UI

const SPEED: float = 300.0
const ATTRACTION_SPEED: float = 150.0

var direction: Vector2 = Vector2.ZERO
var attracted_items: Array[Item] = []
var inventory: Dictionary = {}


func _physics_process(delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.length() > 0:
		direction = direction.normalized()
	if direction:
		animation_player.play("walk")
		velocity = direction * SPEED
		sprite.flip_h = direction.x < 0
	else:
		velocity = Vector2.ZERO
		animation_player.play("idle")

	move_and_slide()

	for item in attracted_items:
		if is_instance_valid(item):
			var direction_to_player = global_position - item.global_position
			item.position += direction_to_player.normalized() * ATTRACTION_SPEED * delta


func collect_item(item: Item) -> void:
	var item_name = item.get_item_name()
	if not inventory.has(item_name):
		inventory[item_name] = 0
	inventory[item_name] += 1
	ui.update_inventory(item, inventory[item_name])
	item.queue_free()


func _on_collection_zone_area_entered(area: Area2D) -> void:
	if area is Item:
		collect_item(area)


func _on_magnet_zone_area_entered(area: Area2D) -> void:
	if area is Item:
		attracted_items.append(area)


func _on_magnet_zone_area_exited(area: Area2D) -> void:
	if area is Item:
		attracted_items.erase(area)
