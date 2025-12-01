@tool
extends Area2D

@export var item_data: ItemData:
    set(value):
        item_data = value
        update_sprite()

@onready var sprite: Sprite2D = $Sprite

func _ready():
    add_to_group("world_item")
    update_sprite()

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
