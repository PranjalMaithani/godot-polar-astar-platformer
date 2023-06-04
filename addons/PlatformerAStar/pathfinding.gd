@tool
class_name PolarPathfinding

const NodeAstar = preload("./DataTypes/node_astar.gd")

static func find_path(parameters: Dictionary):
    var grid
    var start_position = parameters.start_position
    var end_position = parameters.start_position
    var character_config = parameters.character_config
    var start_node
    var target_node
    var open_list: Array[NodeAstar] = []
    var closed_list: Array[NodeAstar] = []

    while (open_list.size() > 0):
        var current_node = open_list[0];
        # get lowest F cost node and mark it as current
        current_node = open_list.reduce(func(prev, current): return current.f < prev.f)
        closed_list.append(current_node)
        open_list.erase(current_node)
        
        if(current_node == target_node):
            var current_path_tile = target_node
            var path: Array[NodeAstar] = []
            var error_safety_count = 100
            while(current_node != start_node):
                path.append(current_node)
                current_node = current_node.connection
                error_safety_count -= 1
                if(error_safety_count < 0):
                    push_error("path count is more than 100")
            
            return current_node
        # var allowedNodes = current_node.


func _enter_tree():
    # Initialization of the plugin goes here.
    pass


func _exit_tree():
    # Clean-up of the plugin goes here.
    pass
