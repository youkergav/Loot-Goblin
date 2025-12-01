extends Panel

@export var inventory_slot_scene: PackedScene

# This is a workaround override to hide the forbidden cursor because there is
# no way to change the default behavior in Godot :)
func _process(_delta: float) -> void:
    if Input.get_current_cursor_shape() == CURSOR_FORBIDDEN:
        DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)

func add_item(item_data: ItemData) -> void:
    var container = $MarginContainer/ScrollContainer/HBoxContainer

    # Try to add item to empty inventory slot
    for inventory_slot in container.get_children():
        if inventory_slot.item_data == null:
            inventory_slot.item_data = item_data
            inventory_slot.update_ui()
            
            return

    # No empty slot found, create a new one
    if inventory_slot_scene:
        var new_slot = inventory_slot_scene.instantiate()
        container.add_child(new_slot)
        new_slot.item_data = item_data
        new_slot.update_ui()

func remove_item(inventory_slot: Panel) -> void:
    if inventory_slot.item_data:
        inventory_slot.item_data = null
        inventory_slot.update_ui()
