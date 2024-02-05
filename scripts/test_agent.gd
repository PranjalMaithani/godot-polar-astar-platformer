extends Node2D

@export var grid_scanner: PolarGridScanner
@export var target_node: Node2D
var pathfinding: PolarPathfinding
@onready var pathfinding_visual: PolarPathFindingVisual = $PathfindingVisual

var temp_bool = false

func _ready():
    await get_tree().create_timer(2).timeout
    temp_bool = true
    print("agent get grid")
    var grid = grid_scanner.get_pathfinding_grid()
    print("agent get grid DONE")
    var pathfinding_parameters = {
        "grid": grid
    }
    pathfinding = PolarPathfinding.new(pathfinding_parameters)

func _process(_delta):
    if(!temp_bool):
        return

    var pathfinding_array = pathfinding.find_path({
        "start_position": position,
        "end_position": target_node.position
    })
    pathfinding_visual.draw_path(pathfinding_array)
