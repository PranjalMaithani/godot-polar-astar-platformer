extends Node2D
class_name PolarPathFindingVisual

var points_to_draw = []
var should_draw_path: bool = false

func _draw():
    if(!should_draw_path):
        return
    draw_path_execute()
    
func draw_path_execute():
    var array_length = points_to_draw.size()
    var previous_point = points_to_draw[0]
    for i in range(1, array_length - 1):
        var next_point = points_to_draw[i]
        draw_line(to_local(previous_point.position), \
                  to_local(next_point.position), \
                  Color.GREEN, 1.0)
        previous_point = next_point

func draw_path(pathfinding_nodes_array) -> void:
    if(!pathfinding_nodes_array):
        return
        
    points_to_draw = pathfinding_nodes_array
    should_draw_path = true
    queue_redraw()

func disable_drawing() -> void:
    should_draw_path = false
