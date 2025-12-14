extends AnimatedSprite2D

@export_group("Animation")
@export_range(0.1, 2.0) var speed_min: float = 0.75
@export_range(0.1, 2.0) var speed_max: float = 1.25

func _ready() -> void:
    play("idle")
    speed_scale = randf_range(0.8, 1.2)
