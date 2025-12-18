extends CharacterBody2D

var speed: int = 100
var direction: Vector2
var health = 220
var alive: bool = true
var player: CharacterBody2D 
    
func _ready() -> void:
    alive = health >= 0
    if alive:
        $Sprite2D.animation = "fly" 
        $ExplosionSprite.hide()    
    if !alive:
        player = null 

func _on_area_2d_body_entered(player_body: CharacterBody2D) -> void:
    if alive:
        player = player_body
          

func _physics_process(_delta: float) -> void:
    if player and alive:
        #var rand = direction.pick_random()
        var dir = (player.position - position).normalized()
        velocity = speed * dir
        #print(str(rand))
        move_and_slide()
    
func _on_detection_area_body_exited(_player_body: CharacterBody2D) -> void:
    player = null 
    print("exit")
    
func _on_explosion_area_body_entered(_player_body: CharacterBody2D) -> void: 
    $Sprite2D.hide()
    $ExplosionSprite.show()
    $AnimationPlayer.play(" explosion")
    health = 0
    print("Drone Health: " + str(health))
    alive = false
    await $AnimationPlayer.animation_finished
    queue_free()  
