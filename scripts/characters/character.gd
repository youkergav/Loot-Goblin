extends CharacterBody2D
class_name Character

@export_group("Movement")
@export var move_speed: float = 120.0
@export var move_acceleration: float = 750.0
@export var move_friction: float = 650.0

@export_group("Health")
@export var health_max: int = 5

@onready var flip_node: Node2D = $FlipNode
@onready var world = get_tree().get_first_node_in_group("world")

var isalive: bool = true 
var health: int 

func _ready() -> void:
    health = health_max

func _physics_process(delta):
    var direction = get_movement_direction()
    apply_movement(direction, delta)

# Used to override in child classes    
func get_movement_direction() -> Vector2:
    return Vector2.ZERO

func apply_movement(direction: Vector2, delta: float):
    # Normalize to prevent faster diagonal movement
    direction = direction.normalized()
    
    if direction != Vector2.ZERO:
        velocity.x = move_toward(velocity.x, move_speed * direction.x, move_acceleration * delta)
        velocity.y = move_toward(velocity.y, move_speed * direction.y, move_acceleration * delta)
        
        update_sprite_direction(direction.x)
        update_animation("walk", direction)
    else:
        velocity.x = move_toward(velocity.x, 0, move_friction * delta)
        velocity.y = move_toward(velocity.y, 0, move_friction * delta)
        
        update_animation("idle", Vector2.ZERO)
    
    move_and_slide()

# Override in child classes to handle animations
func update_animation(_animation_state: String, _direction: Vector2) -> void:
    pass

func update_sprite_direction(horizontal_direction: float) -> void:
    if flip_node != null and horizontal_direction != 0:
        flip_node.scale.x = -1 if horizontal_direction < 0 else 1

func spawn_world_item(world_item_data: Variant, item_position: Vector2) -> WorldItem:
    print("Spawning item off char")
    print(world_item_data)
    # Create the world item
    var world_item_scene = load(world_item_data.world_item_path)
    var new_item = world_item_scene.instantiate()
    new_item.item_data = world_item_data
    new_item.global_position = item_position
    new_item.can_be_picked_up = false  # Block initially
    print("new item: ")
    print(new_item)
    world.call_deferred("add_child", new_item)
    
    # Wait 1 second before allowing pickup
    await get_tree().create_timer(1.0).timeout
    if is_instance_valid(new_item):
        new_item.can_be_picked_up = true
    
    return new_item

func take_damage() -> void:
    if health > 0:
        health -= 1
    #hit animation will go here
    
func heal() -> void:
    health = health_max
