extends CharacterBody2D

var speed: int = 100
var direction: Vector2
var health = 220
var alive: bool = true
var player: CharacterBody2D 
  
    
func _ready() -> void:
    alive = health >= 0
    if !alive: return
    $Sprite2D.animation = "fly" 
    $ExplosionSprite.hide()    
    $RedDot.hide()
    if !alive: return
    player = null 
    
                  

func _physics_process(_delta: float) -> void:
    if !player or !alive: return
    #var rand = direction.pick_random()
    var dir = (player.position - position).normalized()
    velocity = speed * dir
    #print(str(rand))
    move_and_slide()
    
func _on_area_2d_body_entered(player_body: CharacterBody2D) -> void:
    if !alive: return
    player = player_body
    $RedDot.show()
    $RedDotAnimate.play("red")
    
func _on_detection_area_body_exited(_player_body: CharacterBody2D) -> void:
    player = null 
    print("exit")
    
func _on_explosion_area_body_entered(_body: Node2D) -> void: 
    if !alive: return
    explode()
    
    
func explode():
    if not alive: return
    alive = false
    velocity = Vector2.ZERO
    $Sprite2D.hide()
    $ExplosionSprite.show()
    $AnimationPlayer.play(" explosion") 
    $ExplosionSound.play()
    print("Drone Health: " + str(health))
    for drone in get_tree().get_nodes_in_group("Drones"):
        if position.distance_to(drone.position) > 55 or !drone.alive: continue
        drone.explode()
        print("chain reaction")  
    await $AnimationPlayer.animation_finished
    queue_free()
            
func hit():
    if not alive: return
    health -= 110
    print("Bullet hit - Health: " + str(health))
    var tween = create_tween()
    tween.tween_property($Sprite2D.material, "shader_parameter/FloatParameter", 0.0, 0.1)
    tween.tween_property($Sprite2D.material, "shader_parameter/FloatParameter", 1.0, 0.1)
    if health > 0: return
    explode()
    
    
