extends Area2D

var player_in_area = false

func _ready():
    body_entered.connect(_on_body_entered)
    body_exited.connect(_on_body_exited)

func _on_body_entered(body):
    if body.is_in_group("player"):
        player_in_area = true

func _on_body_exited(body):
    if body.is_in_group("player"):
        player_in_area = false

func _process(_delta):
    if player_in_area:
            modulate.a = lerp(modulate.a, 0.55, 0.1)
    else:
        modulate.a = lerp(modulate.a, 1.0, 0.1)
