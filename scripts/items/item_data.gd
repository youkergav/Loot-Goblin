extends Resource
class_name ItemData

@export var item_name: String
@export_file("*.tscn") var world_item_path: String
@export var icon: Texture2D
@export var color: Color
@export var is_equippable: bool = false
@export var is_stackable: bool = false
@export var stack_count: int = 0
