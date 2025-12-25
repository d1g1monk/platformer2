extends Node2D

@export var cam: Camera2D
@export var player: CharacterBody2D
 

var shake_tween: Tween
var is_cinematic: bool = false

func _ready() -> void:
    SignalBus.shake_requested.connect(shake)
    SignalBus.drone_cinematic_requested.connect(focus_on_target)
         
func _physics_process(delta: float) -> void:
    if player:
        global_position = lerp(global_position, player.position, delta * 10)
  
    
func shake(strength: float = 8.0, time: float = 0.15):
    if shake_tween:
        shake_tween.kill()
        
    shake_tween = cam.create_tween()
    shake_tween.tween_property(
        cam, 
        "offset", 
        Vector2(randf_range(-strength, strength), randf_range(-strength, strength)),
        time
    ).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
    
    shake_tween.tween_property(cam, "offset", Vector2.ZERO, time)

func focus_on_target(target_node: Node2D, zoom_level: float = 11, duration: float = 0.5):
    #cam.top_level = true
    is_cinematic = true 
    var tween = create_tween().set_parallel(true)
    
    tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
    tween.set_speed_scale(10)  # Neutralize engin slow down
    #Smoothly move to the drone and zoom in
    tween.tween_property(cam, "global_position", target_node.global_position, duration)
    tween.tween_property(cam, "zoom", Vector2(zoom_level, zoom_level), duration)
    # 3. Wait 1.5 seconds in REAL TIME
    Engine.time_scale = 0.1
    await get_tree().create_timer(2.5, true, false, true).timeout
    return_to_player()
 
func return_to_player():
    var tween = create_tween().set_parallel(true)
    tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE)
    tween.set_speed_scale(10)  # Neutralize engin slow    
    tween.tween_property(cam, "position", Vector2.ZERO, 0.5) # Back to player center
    tween.tween_property(cam, "zoom", Vector2(4, 4), 0.5)
    await tween.finished
    is_cinematic = false
    Engine.time_scale = 1
    
