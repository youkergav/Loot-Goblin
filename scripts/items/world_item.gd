@tool
extends Area2D


@export var item_data: ItemData
        
@export_group("Bob Animation")
@export var bob_preview: bool = true:
    set(value):
        bob_preview = value
        if Engine.is_editor_hint() and not value and sprite:
            # Reset offset when disabling preview
            sprite.offset.y = 0
@export var bob_height: float = 4.0
@export var bob_speed: float = 1.5

@onready var sprite: Sprite2D = $Sprite
@onready var time_offset: float = randf() * TAU

var is_being_magnetized: bool = false

func _process(_delta: float) -> void:
    if not sprite:
        return
        
    # Reset offset if bob_preview is disabled in editor
    if Engine.is_editor_hint() and not bob_preview:
        sprite.offset.y = 0
        return
    
    # Only bob the sprite if not being pulled by magnet
    if not is_being_magnetized:
        var bob_offset = sin(Time.get_ticks_msec() / 1000.0 * bob_speed + time_offset) * bob_height
        sprite.offset.y = bob_offset
