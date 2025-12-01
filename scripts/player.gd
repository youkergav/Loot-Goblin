extends CharacterBody2D

@export_group("Movement")
@export var move_speed: float = 120.0
@export var move_acceleration: float = 750.0
@export var move_friction: float = 650.0

@onready var sprite = $Sprite
@onready var inventory = get_tree().get_first_node_in_group("inventory")

var equipped_item_data: ItemData = null


func _physics_process(delta: float) -> void:
    # Get 2D movement direction
    var direction = Vector2.ZERO
    direction.x = Input.get_axis("ui_left", "ui_right")
    direction.y = Input.get_axis("ui_up", "ui_down")
    
    # Normalize to prevent faster diagonal movement
    direction = direction.normalized()
    
    if direction != Vector2.ZERO:
        velocity.x = move_toward(velocity.x, move_speed * direction.x, move_acceleration * delta)
        velocity.y = move_toward(velocity.y, move_speed * direction.y, move_acceleration * delta)
    else:
        velocity.x = move_toward(velocity.x, 0, move_friction * delta)
        velocity.y = move_toward(velocity.y, 0, move_friction * delta)
    
    move_and_slide()

func _on_pickup_zone_area_entered(area: Area2D) -> void:
    if area.is_in_group("world_item"):
        if pickup_item(area.item_data):
            area.queue_free()

func pickup_item(item_data: ItemData) -> bool:
    if inventory.add_item(item_data):
        print("Picked up: ", item_data.item_name)
        return true
    else:
        print("Inventory full!")
        return false
    
func equip_item(item_data: ItemData) -> ItemData:
    var old_item = equipped_item_data
    equipped_item_data = item_data
    
    sprite.modulate = equipped_item_data.color
    
    return old_item
