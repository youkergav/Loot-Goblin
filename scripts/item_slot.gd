@tool
extends Panel

@export var item_data: ItemData:
    set(value):
        item_data = value
        update_ui()

@onready var icon: TextureRect = $Icon

func _ready():
    update_ui()

func _get_drag_data(_at_position: Vector2) -> Variant:
    if not item_data:
        return

    var preview = duplicate()
    var control = Control.new()
    control.add_child(preview)
    preview.position -= size / 2
    preview.self_modulate = Color.TRANSPARENT
    control.modulate = Color(control.modulate, 0.5)

    set_drag_preview(control)
    return self

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
    return true

func _drop_data(_at_position: Vector2, dropped_slot: Variant) -> void:
    var temp = item_data
    item_data = dropped_slot.item_data
    dropped_slot.item_data = temp

    update_ui()
    dropped_slot.update_ui()

func update_ui() -> void:
    # Safely get icon reference for editor preview
    if not is_inside_tree():
        return

    var icon_node = get_node_or_null("Icon")
    if not icon_node:
        return

    if not item_data:
        icon_node.texture = null
        return

    icon_node.texture = item_data.icon
    tooltip_text = item_data.item_name
