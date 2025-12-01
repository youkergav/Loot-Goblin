extends Control

@export var world_item_scene: PackedScene

@onready var player = get_tree().get_first_node_in_group("player")
@onready var inventory = get_tree().get_first_node_in_group("inventory")
@onready var world = get_tree().get_first_node_in_group("world")
@onready var camera = get_tree().get_first_node_in_group("camera")

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data.item_data != null
	
func _drop_data(at_position: Vector2, inventory_slot: Variant) -> void:
	var item_data = inventory_slot.item_data
	
	inventory.remove_item(inventory_slot)
	
	# Check if equippable, else drop on ground
	if item_data.is_equippable:
		var old_item = player.equip_item(item_data)
		if old_item:
			inventory.add_item(old_item)
	else:
		spawn_item_in_world(item_data, at_position)

func spawn_item_in_world(item_data: ItemData, screen_position: Vector2) -> void:	
	# Convert screen position to world position
	var world_position = camera.global_position + (screen_position - get_viewport_rect().size / 2)
	
	# Create the world item
	var new_item = world_item_scene.instantiate()
	new_item.item_data = item_data
	new_item.global_position = world_position
	
	world.add_child(new_item)
	player.magnet_attracted_items.append(new_item)
	
	print("Dropped non-equippable item: ", item_data.item_name)
