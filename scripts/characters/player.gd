extends Character
class_name Player

@export_group("Magnetic Pull")
@export var magnetic_strength: float = 1500.0
@export var min_magnetic_strength: float = 125.0
@export var max_magnetic_strength: float = 3000.0

@export_group("Health")
@export var damage_recovery_time_limit: float = 2.0

@onready var sprite: Sprite2D = $Sprites/Body
@onready var hotbar: Hotbar = get_tree().get_first_node_in_group("hotbar")
@onready var hurtbox: Area2D = $HurtBox
@onready var worldDropZone: Control = $"../../UI/WorldDropZone"
@onready var camera = get_tree().get_first_node_in_group("camera")

var magnet_attracted_items: Array = []

var equipped_item_data: ItemData = null
var equipment: Variant

var hearts_list : Array[TextureRect]

var is_invulnerable : bool = false
var damage_recovery_timer : float

func _physics_process(delta: float) -> void:
    pull_magnetized_items(delta)
    super._physics_process(delta)
    if is_invulnerable:
        check_invulnerability(delta)


func _on_item_pickup_zone_area_entered(area: Area2D) -> void:
    if area.is_in_group("world_item"):
        pickup_item(area.item_data)
        area.queue_free()
        magnet_attracted_items.erase(area)

func _on_item_magnet_zone_area_entered(area: Area2D) -> void:
    if area.is_in_group("world_item"):
        magnet_attracted_items.append(area)
        area.is_being_magnetized = true
        area.modulate.a = 0.5  # Make item 50% transparent
        
        if shadow:
            shadow.visible = false

func _on_item_magnet_zone_area_exited(area: Area2D) -> void:
    magnet_attracted_items.erase(area)
    if is_instance_valid(area):
        area.is_being_magnetized = false
        area.modulate.a = 1.0  # Restore full opacity

func get_movement_direction() -> Vector2:
    var direction = Vector2.ZERO
    direction.x = Input.get_axis("ui_left", "ui_right")
    direction.y = Input.get_axis("ui_up", "ui_down")
    return direction

func pull_magnetized_items(delta):
    for item in magnet_attracted_items:
        if is_instance_valid(item):
            pull_item_towards_player(item, delta)

func pull_item_towards_player(item, delta):
    var direction = global_position - item.global_position
    var distance = direction.length()

    if distance > 0:
        # Generate pull force of linear and inverse square component.
        var linear_pull = magnetic_strength / distance
        var squared_boost = (magnetic_strength * 200.0) / (distance * distance)
        var pull_force = linear_pull + squared_boost

        pull_force = clamp(pull_force, min_magnetic_strength, max_magnetic_strength)

        # Clamp to distance of player so we dont overshoot.
        var movement = pull_force * delta
        if movement > distance:
            movement = distance

        item.global_position += direction.normalized() * movement

func pickup_item(item_data: ItemData) -> void:
    hotbar.add_item(item_data)
    print("Picked up: ", item_data.item_name)

func update_player_color() -> void:
    if equipped_item_data.is_equippable:
        sprite.modulate = equipped_item_data.color
    else:
        sprite.modulate = Color.WHITE

func equip_item(item_data: ItemData) -> void:
    #use this to generically update the equip slot
    #regardless of if it is equipment or not

    #check if the new equipment is the same as the old
    if item_data == equipped_item_data:
        return

    #start by clearing out the old equipment
    remove_equipment()

    equipped_item_data = item_data
    
    #if the item is equippable then set the equipment
    if equipped_item_data.is_equippable:
        #create new equpment and make it a child of player
        print("adding new child")
        equipment = equipped_item_data.equipment_scene.instantiate()
        self.call_deferred("add_child", equipment)
        
    
    print("equipping " + equipped_item_data.item_name)
    update_player_color()

func remove_equipment() -> void:
    if equipment:
        self.call_deferred("remove_child", equipment)
        equipment.queue_free()
        

func drop_equipped_item() -> void:
    #remove player equipment
    remove_equipment()

    #clean up item data and send a copy to the world
    if equipped_item_data != null:
        super.spawn_world_item(equipped_item_data, self.position)
        equipped_item_data = null

    #update the hotbar last
    hotbar.remove_equipped_item_and_shift()



func _ready() -> void: 
    var hearts_parent = $"../../UI/Heartbar/HBoxContainer"
    for child in hearts_parent.get_children():
        hearts_list.append(child)
    print (hearts_list)
    super._ready()

func check_invulnerability(delta):
    damage_recovery_timer += delta
    if(damage_recovery_timer > damage_recovery_time_limit):
        is_invulnerable = false
        damage_recovery_timer = 0
        if has_overlapping_hit():
            take_damage()
        

func take_damage() -> void:
    if is_invulnerable:
        return
    super.take_damage()
    for i in range (hearts_list.size()):
        hearts_list[i].visible = i < health
    if health == 1:
        #hearts_list[0].play()
        #play danger animation
        pass
    elif health > 1:
        #play regular animation
        #hearts_list[0].play()
        pass
    elif health <= 0:
        isalive = false
        #end screen 
        #death() #dath Animation
        return
    is_invulnerable = true
    damage_recovery_timer = 0
    
func has_overlapping_hit() -> bool:
    for overlap_area in hurtbox.get_overlapping_areas():
        if overlap_area.is_in_group("hit"):
            return true
    return false
    
func _on_hurt_box_area_entered(area: Area2D) -> void:
    if area.is_in_group("hit"):
        print("Hit!")
        take_damage()
