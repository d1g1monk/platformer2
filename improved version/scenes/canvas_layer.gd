extends Node2D

 

func _process(_delta: float) -> void:
    if GameManager.reset_label == true:
        $Label.global_position = Vector2.ZERO  
    if !(GameManager.toggle_label == true): return 
    if GameManager.reset_label: return
    var drone: CharacterBody2D = get_tree().get_first_node_in_group("DroneGroup")
    $Label.global_position = drone.global_position  
       
    
 
