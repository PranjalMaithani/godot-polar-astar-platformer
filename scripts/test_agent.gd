extends Node2D

@export var grid_scanner: PolarGridScanner
@export var target_node: Node2D
var pathfinding: PolarPathfinding

func _ready():
    var grid = grid_scanner.get_pathfinding_grid()
    var pathfinding_parameters = {
        "grid": grid
    }
    pathfinding = PolarPathfinding.new(pathfinding_parameters)

    var pathfinding_array = pathfinding.find_path({
        "start_position": position,
        "end_position": target_node.position
    })
    print("pathfinding array = ")
    print(pathfinding_array)
