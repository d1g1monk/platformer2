extends Node2D


@onready var current_world := $World
var bullet_scene: PackedScene = preload("res://scenes/bullet/bullet.tscn")

func _ready():
    SignalBus.level_change_requested.connect(load_level)

func load_level(level_path: String):
    call_deferred("_do_load_level", level_path)

func _do_load_level(level_path: String):
    var main = get_tree().root.get_node("Main")
    var new_world = load(level_path).instantiate()
    main.add_child(new_world)


    # Make sure you reference bullets correctly
     # same for drones or enemies
 
    await get_tree().process_frame
    if current_world:
        current_world.queue_free()
    
    current_world = new_world




        
func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
    var bullet = bullet_scene.instantiate()
    bullet.setup(pos, dir)
    if !current_world: return
    current_world.get_node("Bullets").add_child(bullet)
    
