extends Panel


# This is a workaround override to hide the forbidden cursor because there is
# no way to change the default behavior in Godot :)
func _process(_delta: float) -> void:
    if Input.get_current_cursor_shape() == CURSOR_FORBIDDEN:
        DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)

func add_item(item_data: ItemData) -> bool:
    var container = $MarginContainer/ScrollContainer/HBoxContainer

    for inventory_slot in container.get_children():
        if inventory_slot.item_data == null:
            inventory_slot.item_data = item_data
            inventory_slot.update_ui()

            return true

    return false

func remove_item(inventory_slot: Panel) -> void:
    if inventory_slot.item_data:
        inventory_slot.item_data = null
        inventory_slot.update_ui()
