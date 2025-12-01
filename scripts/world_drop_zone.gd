extends Control

@onready var player = get_tree().get_first_node_in_group("player")
@onready var inventory = get_tree().get_first_node_in_group("inventory")

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
    return data.item_data != null and data.item_data.is_equippable
    
func _drop_data(_at_position: Vector2, inventory_slot: Variant) -> void:
    var old_item = player.equip_item(inventory_slot.item_data)
    
    inventory.remove_item(inventory_slot)
    if old_item:
        inventory.add_item(old_item)
