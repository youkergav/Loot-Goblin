@tool
extends Area2D


@export var item_data: ItemData:
    set(value):
        item_data = value
        update_sprite()
        
@export_group("Bob Animation")
@export var bob_height: float = 4.0
@export var bob_speed: float = 1.5

@onready var sprite: Sprite2D = $Sprite
@onready var base_sprite_y: float = sprite.position.y  # Store sprite's Y, not Area2D's Y
@onready var time_offset: float = randf() * TAU

var is_being_magnetized: bool = false  # Track if item is being pulled


func _ready():
    update_sprite()

func _process(_delta: float) -> void:
    # Only bob the sprite if not being pulled by magnet
    if not is_being_magnetized and sprite:
        var bob_offset = sin(Time.get_ticks_msec() / 1000.0 * bob_speed + time_offset) * bob_height
        sprite.position.y = base_sprite_y + bob_offset

func update_sprite() -> void:
    if not is_inside_tree():
        return
    
    var sprite_node = get_node_or_null("Sprite")
    if not sprite_node:
        return
    
    if item_data:
        sprite_node.texture = item_data.icon
    else:
        sprite_node.texture = null
