extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/bullets/bullet.tscn")

func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
    var bullet = bullet_scene.instantiate() as Area2D
    bullet.setup(pos, dir)
    $Bullets.add_child(bullet)   
    print(str(pos) + " " + str(dir))
