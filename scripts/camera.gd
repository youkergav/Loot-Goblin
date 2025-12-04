extends Camera2D

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
    position.x = player.position.x
