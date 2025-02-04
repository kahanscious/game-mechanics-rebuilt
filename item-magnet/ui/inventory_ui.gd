class_name InventoryUI extends CanvasLayer

@onready var wood_count: Label = $Banner/ItemContainer/Wood/Count
@onready var meat_count: Label = $Banner/ItemContainer/Meat/Count
@onready var gold_count: Label = $Banner/ItemContainer/Gold/Count


func update_inventory(item: Item, count: int) -> void:
	if item is Wood:
		wood_count.text = str(count)
	elif item is Gold:
		gold_count.text = str(count)
	elif item is Meat:
		meat_count.text = str(count)
