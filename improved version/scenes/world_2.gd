extends Node2D

func _ready() -> void:
    GameManager.player.global_position = GameManager.next_spawn
    GameManager.player.global_position += Vector2(200, 200)
    #GameManager.world2 = $World2
