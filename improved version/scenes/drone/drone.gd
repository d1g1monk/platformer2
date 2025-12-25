extends CharacterBody2D

var direction: Vector2
var speed: int = 50
var boost_speed: int = speed * 2
var health: int = 200

var player: CharacterBody2D  
  
var alive: bool = true  

 
func _ready() -> void:
    $AnimationPlayer.play("fly")
    $Sprite2D.material = $Sprite2D.material.duplicate(true) # Makes each drone unique
    $PointLight2D.hide()
    GameManager.drone_alive = true

    
func _exit_tree():
    if GameManager.drone == self:
        GameManager.drone = null
 
func _physics_process(_delta: float) -> void:
    if !player or !alive: return
    var rough_dir: Vector2 = (player.position - position) 
    var boost_dist = rough_dir.length()  # Pytagorean theorem. Shortest straight line between targets
    var dir = rough_dir / boost_dist    # normalize
    var t = clamp(1.0 - boost_dist / 110.0, 0.0, 1.0)
    if boost_dist < 150:
        velocity = boost_speed * dir
        $PointLight2D.scale = Vector2(lerp(0.2, 1.5, t), 0.02)
        #var tween: Tween = create_tween()
        #tween.tween_property($PointLight2D, "scale", Vector2(0.8, 0.02), 0.3) 
    else: 
        velocity = speed * dir
    move_and_slide()

func _on_detection_zone_body_entered(body: Node2D) -> void:
    if !(body.name == "Player") and !(body.name == "Drone"): return
    if body.name == "Player":
        player = body  
        GameManager.toggle_label = true
        GameManager.reset_label = false
        print(GameManager.toggle_label)
    $PointLight2D.show()
    #var tween: Tween = create_tween()
    #tween.tween_property($PointLight2D, "scale", Vector2(0.2, 0.02), 0.3) 
    SignalBus.drone_cinematic_requested.emit(self)
    
func _on_detection_zone_body_exited(body: Node2D) -> void:
    if !(body.name == "Player"): return 
    player = null
    $PointLight2D.hide()
    #var tween: Tween = create_tween()
    #tween.tween_property($PointLight2D, "scale", Vector2(0, 0), 0.3)
    GameManager.toggle_label = false
    GameManager.reset_label = true
    print(GameManager.toggle_label)
    
func take_damage(amount: int):
    if not alive: return
    health -= amount
    shader_dmg()
    $HitSound.play()
    if health > 0: return
    explode()

func shader_dmg():
    var tween: Tween = create_tween()
    tween.tween_property($Sprite2D.material, "shader_parameter/FloatParameter", 1.0, 0.1).from(0.1)
    
func explode() -> void:
    if !alive: return 
    $ExplosionSprite.show()
    $AnimationPlayer.play("explode")
    $ExplosionSound.play()
    $Sprite2D.hide()
    $PointLight2D.hide()
    GameManager.drone_alive = false
    SignalBus.shake_requested.emit(10.0, 0.2)
    #get_tree().call_group("Camera", "shake", 10.0, 0.2)
    alive = false    
    chain_reaction()
    set_physics_process(false) 
    $CollisionShape2D.set_deferred("disabled", true)
    await $AnimationPlayer.animation_finished
    queue_free()

func chain_reaction():
    var react_time = get_tree().create_timer(0.55)
    await react_time.timeout
    for drone in get_tree().get_nodes_in_group("DroneGroup"):
        if drone == self: continue
        if position.distance_to(drone.position) > 55: continue
        print("Chain reaction")  
        drone.explode()
      
     
func _on_explosion_area_body_entered(body: Node2D) -> void:  
    if body == self: return
    take_damage(200)
