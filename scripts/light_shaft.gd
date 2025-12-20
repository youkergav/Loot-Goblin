extends Node2D
class_name LightShaft


@export var fade_duration: float = 0.5

@export_group("Energy")
@export var min_energy: float = 0.0
@export var max_energy: float = 0.3

@export_group("Speed")
@export var min_speed: float = 0.3
@export var max_speed: float = 0.6

var lights = []
var is_fading = false


func _ready():
    lights = $AnimatedPointLight2D.get_children().filter(func(child): return child is PointLight2D)
    
    for light in lights:
        animate_light(light)

func animate_light(light: PointLight2D):
    if is_fading:
        return
        
    var speed = randf_range(min_speed, max_speed)
    var target_energy = randf_range(min_energy, max_energy)
    
    var tween = create_tween()
    tween.tween_property(light, "energy", target_energy, speed).set_ease(Tween.EASE_IN_OUT)
    tween.finished.connect(func(): animate_light(light))
    
func fade_out(delay: float = 0):
    await get_tree().create_timer(delay).timeout # Add a small delay before fading
    
    is_fading = true
    
    # Fade out base light shaft
    var base_tween = create_tween()
    base_tween.tween_property($BasePointLight2D, "energy", 0.0, fade_duration)
    
    # Fade out animated light shafts
    for light in lights:
        var tween = create_tween()
        tween.tween_property(light, "energy", 0.0, fade_duration)
    
    await get_tree().create_timer(fade_duration).timeout
    queue_free()
