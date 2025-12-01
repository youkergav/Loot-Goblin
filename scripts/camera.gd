extends Camera2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

var center_offset: float
var level_width: float

func _ready() -> void:
    center_offset = get_viewport_rect().size.x / 2.0
    level_width = get_tree().get_first_node_in_group("sky").region_rect.size.x

func _process(_delta: float) -> void:
    position.x = clamp(player.position.x, center_offset, level_width - center_offset)
