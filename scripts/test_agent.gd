extends Node2D

@export var target_node: Node2D
@onready var pathfinding: PolarPathfinding = %Pathfinding
@onready var pathfinding_visual: PolarPathFindingVisual = $PathfindingVisual

var temp_bool = false

func _ready():
    await get_tree().create_timer(2).timeout
    temp_bool = true

func _process(_delta):
    if(!temp_bool):
        return

    var pathfinding_array = pathfinding.find_path({
        "start_position": position,
        "end_position": target_node.position
    })
    pathfinding_visual.draw_path(pathfinding_array)
