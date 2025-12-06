@tool
extends Area2D


@export var item_data: ItemData
        
@export_group("Bob Animation")
@export var bob_preview: bool = true
@export var bob_height: float = 4.0
@export var bob_speed: float = 1.5

@onready var sprite: Sprite2D = $Sprite
@onready var base_sprite_y: float = sprite.position.y
@onready var time_offset: float = randf() * TAU

var is_being_magnetized: bool = false


func _process(_delta: float) -> void:
    # Ignore if bob_run is disabled for inspector
    if Engine.is_editor_hint() and not bob_preview:
        sprite.position.y = base_sprite_y
        return
    
    # Only bob the sprite if not being pulled by magnet
    if not is_being_magnetized and sprite:
        var bob_offset = sin(Time.get_ticks_msec() / 1000.0 * bob_speed + time_offset) * bob_height
        sprite.position.y = base_sprite_y + bob_offset
