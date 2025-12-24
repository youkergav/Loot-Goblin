extends Control

@export var world_item_scene: PackedScene

@onready var player = get_tree().get_first_node_in_group("player")
@onready var hotbar = get_tree().get_first_node_in_group("hotbar")
@onready var world = get_tree().get_first_node_in_group("world")
@onready var camera = get_tree().get_first_node_in_group("camera")

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
    return data.item_data != null

func _drop_data(at_position: Vector2, item_slot: Variant) -> void:
    var item_data = item_slot.item_data

    # Remove from queue and shift everything left
    hotbar.remove_item_and_shift(item_slot)

    spawn_item_in_world(item_data, at_position)


func spawn_item_in_world(item_data: ItemData, screen_position: Vector2) -> void:
    # Convert screen position to world position
    var camera_center = camera.get_screen_center_position()
    var world_position = camera_center + (screen_position - get_viewport_rect().size / 2)

    # Load the scene from the path
    var world_scene = load(item_data.world_item_path)
    var new_item = world_scene.instantiate()
    new_item.item_data = item_data
    new_item.global_position = world_position
    new_item.can_be_picked_up = false

    world.add_child(new_item)

    # Wait 1 second before allowing magnetization
    await get_tree().create_timer(1.0).timeout
    if is_instance_valid(new_item):
        new_item.can_be_picked_up = true
        player.magnet_attracted_items.append(new_item)

    print("Dropped: ", item_data.item_name)
