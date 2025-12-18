extends CharacterBody2D

var speed: int = 200
var direction: Vector2
var health = 100

@export var jump_strength: float = 500
@export var gravity: float = 1220
signal shoot(pos: Vector2, dir: Vector2)
const gun_directions: Dictionary = {
    Vector2i(1,0)   : 0,
    Vector2i(1,1)   : 1,
    Vector2i(0,1)   : 2,
    Vector2i(-1,1)  : 3,
    Vector2i(-1,0)  : 4,
    Vector2i(-1,-1) : 5,
    Vector2i(0,-1)  : 6,
    Vector2i(1,-1)  : 7,
}

func _physics_process(delta: float) -> void:
    #direction = Input.get_vector("left", "right", "jump", "shoot")
    reset_pos()
    get_input()  
    velocity.x = speed * direction.x
    apply_gravity(delta)
    move_and_slide()
    animation()
    update_marker()
    
func apply_gravity(delta):
    velocity.y += gravity * delta

func reset_pos() -> void:
    if position.y > 720:
        position = Vector2(20, 0)
    
func get_input():
    direction.x = Input.get_axis("left", "right")
    if Input.is_action_just_pressed("jump"):
        velocity.y -= jump_strength
    if Input.is_action_just_pressed("shoot") and $ShootTimer.time_left == 0:
        shoot.emit(position, get_local_mouse_position().normalized())
        $ShootTimer.one_shot = true
        $ShootTimer.start(0.5)
        # Tween is short for inbetween. We will use this instead of animationplayer as this is simpler.
        var tween = get_tree().create_tween()
        tween.tween_property($Marker, "scale", Vector2(0.1, 0.1), 0.2)
        tween.tween_property($Marker, "scale", Vector2(0.5, 0.5), 0.2)
         
func animation():
    if is_on_floor():
        $AnimationPlayer.current_animation = "run" if direction.x else "idle"
        $Legs.flip_h = direction.x < 0
    else:
        $AnimationPlayer.current_animation = "jump"
    var dir = get_local_mouse_position().normalized()
    var round_dir = Vector2i(round(dir.x), round(dir.y))
    $Torso.frame = gun_directions[round_dir]
    

func update_marker():
    $Marker.position = get_local_mouse_position().normalized() * 70
