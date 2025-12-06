extends TextureRect
class_name Hotbar

@export var item_slot_scene: PackedScene
@export var normal_equip_border_texture: Texture2D
@export var active_equip_border_texture: Texture2D

@onready var slot_container = $ScrollContainer/SlotContainer
@onready var player = get_tree().get_first_node_in_group("player")

func _ready() -> void:
    update_equipped_item()

# This is a workaround override to hide the forbidden cursor because there is
# no way to change the default behavior in Godot... :)
func _process(_delta: float) -> void:
    if Input.get_current_cursor_shape() == CURSOR_FORBIDDEN:
        DisplayServer.cursor_set_shape(DisplayServer.CURSOR_ARROW)

func add_item(item_data: ItemData) -> void:
    # Queue system - always add to the rightmost empty slot
    for item_slot in slot_container.get_children():
        if item_slot.item_data == null:
            item_slot.item_data = item_data
            item_slot.update_ui()
            update_equipped_item()
            return

    # No empty slot found, create a new one
    if item_slot_scene:
        var new_slot = item_slot_scene.instantiate()
        slot_container.add_child(new_slot)
        new_slot.item_data = item_data
        new_slot.update_ui()
        update_equipped_item()

func remove_item_and_shift(removed_slot: TextureRect) -> void:
    var slots = slot_container.get_children()
    var removed_index = slots.find(removed_slot)
    
    if removed_index == -1:
        return
    
    # Shift all items from right to left
    for i in range(removed_index, slots.size() - 1):
        slots[i].item_data = slots[i + 1].item_data
        slots[i].update_ui()
    
    # Clear the last slot
    slots[slots.size() - 1].item_data = null
    slots[slots.size() - 1].update_ui()
    
    # Update what's equipped after queue shift
    update_equipped_item()

func update_equipped_item() -> void:
    var slots = slot_container.get_children()
    var border = slots[0].get_node("Border")
    
    # Check if first slot has an equippable item
    if slots.size() > 0 and slots[0].item_data and slots[0].item_data.is_equippable:
        # Equip the first slot's item
        player.equip_item(slots[0].item_data)
        # Change the border to activate.
        border.texture = active_equip_border_texture
    else:
        # First slot is empty or not equippable - unequip
        player.equipped_item_data = null
        player.sprite.modulate = Color.WHITE
        
        # Change the border to normal.
        border.texture = normal_equip_border_texture
