extends CharacterBody2D
class_name Character

@export_group("Movement")
@export var move_speed: float = 120.0
@export var move_acceleration: float = 750.0
@export var move_friction: float = 650.0

@export_group("Health")
@export var health_max: int = 5

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
    else:
        velocity.x = move_toward(velocity.x, 0, move_friction * delta)
        velocity.y = move_toward(velocity.y, 0, move_friction * delta)
    
    move_and_slide()

func take_damage() -> void:
    if health > 0:
        health -= 1
    #hit animation will go here
    
func heal() -> void:
    health = health_max
   
