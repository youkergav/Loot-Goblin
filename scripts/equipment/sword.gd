extends Node

@onready var hitBox: Area2D = $HitBox
@onready var hitBoxTrigger: Area2D = $HitBoxTrigger

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    if is_trigger_active():
        attack()
    
func attack() -> void:
    #check hitbox for collisions
    var hit_counter = 0
    for area in hitBoxTrigger.get_overlapping_areas():
        if area.is_in_group("hurtbox_enemy"):
            area.get_parent().take_damage()
            hit_counter += 1
    if(hit_counter > 0):
        self.get_parent().drop_equipped_item()

func is_trigger_active() -> bool:
    for area in hitBox.get_overlapping_areas():
        if area.is_in_group("hurtbox_enemy"):
            return true
    return false

func _on_hit_box_trigger_area_entered(area: Area2D) -> void:
    if area.is_in_group("hurtbox_enemy"):
        attack()
