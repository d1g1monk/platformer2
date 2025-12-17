extends CharacterBody2D

var speed: int = 400
var direction: Vector2
@export var jump_strength: float = 400
@export var gravity: float = 1220
signal shoot(pos: Vector2, dir: Vector2)

func _physics_process(delta: float) -> void:
    #direction = Input.get_vector("left", "right", "jump", "shoot")
    reset_pos()
    get_input()  
    velocity.x = speed * direction.x
    apply_gravity(delta)
    move_and_slide()
    animation()
    
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
        

func animation():
    if is_on_floor():
        $AnimationPlayer.current_animation = "run" if direction.x else "idle"
        $Legs.flip_h = direction.x < 0
    else:
        $AnimationPlayer.current_animation = "jump"
        
         
