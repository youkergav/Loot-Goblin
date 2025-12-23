extends CanvasGroup

@onready var player = get_tree().get_first_node_in_group("player")

func _process(_delta: float) -> void:
    var player_screen_pos = get_viewport_transform() * player.global_position
    material.set_shader_parameter("player_screen_position", player_screen_pos)
