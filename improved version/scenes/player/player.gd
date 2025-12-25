extends CharacterBody2D


var speed: int = 200
var direction: Vector2
var jump_force: int = 655
var gravity: int = 2700
var jump_count: int 
var gun_direction: Dictionary = {
    Vector2i(1, 0)  : 0,
    Vector2i(1, 1)  : 1,
    Vector2i(0, 1)  : 2,
    Vector2i(-1, 1) : 3,
    Vector2i(-1, 0) : 4,
    Vector2i(-1, -1): 5,
    Vector2i(0, -1) : 6,
    Vector2i(1, -1) : 7,
}

signal shoot(pos: Vector2, dir: Vector2)


func _ready():
    GameManager.player = self
 
      
func _physics_process(delta: float) -> void:
    position_marker()
    animate()
    get_input()
    grav(delta)
    move_and_slide()
    
func grav(delta):
    velocity.y += gravity * delta
    
func get_input():
    direction.x = Input.get_axis("left", "right")
    velocity.x = speed * direction.x
    if is_on_floor():
        jump_count = 2 
    if Input.is_action_just_pressed("jump") and jump_count > 0:
            velocity.y = -jump_force
            jump_count -= 1
            if !is_on_floor():
                jump_count -= 1
    if Input.is_action_just_pressed("shoot") and $ShootTimer.time_left == 0:
        shoot.emit(position, get_local_mouse_position().normalized())
        $ShootTimer.one_shot = true
        $ShootTimer.start(0.5)
        var tween = create_tween()
        tween.tween_property($Marker, "scale", Vector2(0.3, 0.3), 0.1).from(Vector2(0.1, 0.1))
    
     
func animate():
    if is_on_floor():
        $AnimationPlayer.current_animation = "run" if direction.x else "idle"
        $Legs.flip_h = direction.x < 0
    else:
        $AnimationPlayer.current_animation = "jump" 
    var dir = get_local_mouse_position().normalized()
    var round_dir = Vector2i(round(dir.x), round(dir.y))
    $Torso.frame = gun_direction[round_dir]
    
        
func position_marker():
    $Marker.position = get_local_mouse_position()
           
        
