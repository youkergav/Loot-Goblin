extends Character
class_name Enemy


@export_group("AI")
@export var reaction_time: float = 0.3
@export var stop_distance: float = 30.0
@export var pause_chance: float = 0.02
@export var pause_duration: float = 0.5

@onready var player: Player = get_tree().get_first_node_in_group("player")
@onready var detection_zone = $PlayerDetectionZone

var player_in_range: bool = false
var reaction_timer: float = 0.0
var should_chase: bool = false
var movement_offset: Vector2 = Vector2.ZERO
var offset_timer: float = 0.0
var is_paused: bool = false
var pause_timer: float = 0.0


func _ready() -> void:
    super._ready()
    randomize_movement_speed()

func _physics_process(delta: float) -> void:
    update_pause_state(delta)
    update_chase_state(delta)
    update_movement_variation(delta)
    
    super._physics_process(delta)

func _on_player_detection_zone_body_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        player_in_range = true

func _on_player_detection_zone_body_exited(body: Node2D) -> void:
    if body.is_in_group("player"):
        player_in_range = false

func get_movement_direction() -> Vector2:
    if is_paused or not should_chase:
        return Vector2.ZERO
    
    var target_pos = player.global_position + movement_offset
    var distance_to_target = global_position.distance_to(target_pos)
    
    if distance_to_target > stop_distance:
        return (target_pos - global_position).normalized()
    
    return Vector2.ZERO

func randomize_movement_speed() -> void:
    move_speed *= randf_range(0.8, 1.2)

func update_pause_state(delta: float) -> void:
    if is_paused:
        pause_timer -= delta
        if pause_timer <= 0:
            is_paused = false
    elif should_chase and randf() < pause_chance:
        is_paused = true
        pause_timer = randf_range(0.3, pause_duration)

func update_chase_state(delta: float) -> void:
    if player_in_range and not should_chase:
        reaction_timer += delta
        if reaction_timer >= reaction_time:
            should_chase = true
    elif not player_in_range:
        should_chase = false
        reaction_timer = 0.0

func update_movement_variation(delta: float) -> void:
    offset_timer += delta
    if offset_timer >= randf_range(0.5, 1.0):
        movement_offset = Vector2(randf_range(-15, 15), randf_range(-15, 15))
        offset_timer = 0.0
