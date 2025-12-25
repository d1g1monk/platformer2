extends Area2D

@export var target_level: String
@export var spawn_location: Vector2

func _on_body_entered(body):
    if body.is_in_group("Player"):
        GameManager.next_spawn = spawn_location
        SignalBus.emit_signal("level_change_requested", target_level)
