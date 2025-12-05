extends Character
class_name Player

@export_group("Magnetic Pull")
@export var magnetic_strength: float = 1500.0
@export var min_magnetic_strength: float = 125.0
@export var max_magnetic_strength: float = 3000.0

@onready var sprite = $Sprites/Body
@onready var hotbar = get_tree().get_first_node_in_group("hotbar")

var magnet_attracted_items: Array = []
var equipped_item_data: ItemData = null

var hearts_list : Array[TextureRect]

func _physics_process(delta: float) -> void:
    pull_magnetized_items(delta)
    super._physics_process(delta)

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
        
        var shadow = area.get_node_or_null("Shadow")
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

func equip_item(item_data: ItemData) -> ItemData:
    var old_item = equipped_item_data
    equipped_item_data = item_data

    sprite.modulate = equipped_item_data.color

    return old_item

func _ready() -> void: 
    var hearts_parent = $"../../UI/Heartbar/HBoxContainer"
    for child in hearts_parent.get_children():
        hearts_list.append(child)
    print (hearts_list)
    super._ready()

func take_damage() -> void:
    super.take_damage()
    for i in range (hearts_list.size()):
        hearts_list[i].visible = i < health
    if health == 1:
        hearts_list[0].play()
    elif health > 1:
        hearts_list[0].play()
    elif health <= 0:
        isalive = false 
        #end screen 
        #death() #dath Animation 
    
