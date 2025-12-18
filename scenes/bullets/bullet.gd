extends Area2D

var direction: Vector2

func _ready() -> void:
    var tween = get_tree().create_tween()
    tween.tween_property($Sprite2D, "scale", Vector2(2, 2), 0.4).from(Vector2.ZERO)
    
func setup(pos: Vector2, dir: Vector2):
    position = pos + dir * 12
    direction = dir
    
func _physics_process(delta: float) -> void:
    position += direction * 230 * delta
    


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    queue_free()
