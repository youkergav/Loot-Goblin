extends CharacterBody2D

@export_group("Movement")
@export var move_speed: float = 120.0
@export var move_acceleration: float = 750.0
@export var move_friction: float = 650.0

@export_group("Magnetic Pull")
@export var magnetic_strength: float = 1500.0
@export var min_magnetic_strength: float = 125.0
@export var max_magnetic_strength: float = 3000.0

@onready var sprite = $Sprite
@onready var inventory = get_tree().get_first_node_in_group("inventory")

var magnet_attracted_items: Array = []
var equipped_item_data: ItemData = null


func _physics_process(delta: float) -> void:
    move_player(delta)

    for item in magnet_attracted_items:
        if is_instance_valid(item):
            pull_item_towards_player(item, delta)

func _on_item_pickup_zone_area_entered(area: Area2D) -> void:
    if area.is_in_group("world_item"):
        pickup_item(area.item_data)
        area.queue_free()
        magnet_attracted_items.erase(area)

func _on_item_magnet_zone_area_entered(area: Area2D) -> void:
    if area.is_in_group("world_item"):
        magnet_attracted_items.append(area)

func _on_item_magnet_zone_area_exited(area: Area2D) -> void:
    magnet_attracted_items.erase(area)

func move_player(delta):
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

func pull_item_towards_player(item, delta):
    var direction = global_position - item.global_position
    var distance = direction.length()

    if distance > 0:
        # Generate pull force of linear and inverse square component.
        var linear_pull = magnetic_strength / distance
        var squared_boost = (magnetic_strength * 200.0) / (distance * distance)
        var pull_force = linear_pull + squared_boost

        pull_force = clamp(pull_force, min_magnetic_strength, max_magnetic_strength)

        # Clamp to distance of player so we dont overshoot.
        var movement = pull_force * delta
        if movement > distance:
            movement = distance

        item.global_position += direction.normalized() * movement

func pickup_item(item_data: ItemData) -> void:
    inventory.add_item(item_data)
    print("Picked up: ", item_data.item_name)

func equip_item(item_data: ItemData) -> ItemData:
    var old_item = equipped_item_data
    equipped_item_data = item_data

    sprite.modulate = equipped_item_data.color

    return old_item
