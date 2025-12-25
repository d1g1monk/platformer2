extends Area2D

var speed: int = 400
var direction: Vector2

func _ready() -> void:
    var tween = create_tween()
    tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 0.1).from(Vector2(0, 0))
    $AudioStreamPlayer2D.play()
    
func setup(pos:Vector2, dir:Vector2) -> void:
    direction = dir
    position = pos + dir * 12

func _physics_process(delta: float) -> void:
    position += direction * speed * delta
    
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()


func _on_body_entered(body: Node2D) -> void:
    if !("take_damage" in body): return
    body.take_damage(100)
    print("Bullet hit")
    queue_free()
