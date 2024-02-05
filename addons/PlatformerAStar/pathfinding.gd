@tool
class_name PolarPathfinding

const Array2d = preload("./DataTypes/array2d.gd")
const NodeAstar = preload("./DataTypes/node_astar.gd")
const TileAstar = preload("./DataTypes/tile_astar.gd")
const GridAstar = preload("./DataTypes/grid_astar.gd")
const PathfindingNode = preload("./DataTypes/pathfinding_node.gd")

var grid: GridAstar
var node_grid: Array2d
var character_config: Dictionary = {
    "name": "default",
    "flying": true,
    "size": Vector2(1,1)
} #TODO: create character config resource class

func _init(parameters: Dictionary):
    grid = parameters.grid
    node_grid = Array2d.new(grid.x_tiles, grid.y_tiles)
    if(parameters.get("character_config")):
        character_config = parameters.character_config

func get_lowest_f_cost_node(prev: NodeAstar, current: NodeAstar):
    if(prev == null):
        return current
    if(current.f < prev.f || (current.f == prev.f && current.h < prev.h)):
        return current
    return prev

func find_path(parameters: Dictionary):
    node_grid.reset_values(null);
    var start_position = parameters.start_position
    var end_position = parameters.end_position

    var start_xy = grid.get_xy_from_position(start_position)
    var start_x = start_xy.x
    var start_y = start_xy.y
    var end_xy = grid.get_xy_from_position(end_position)
    var end_x = end_xy.x
    var end_y = end_xy.y

    if(start_x < 0 || start_y < 0 || start_x >= grid.x_tiles || start_y >= grid.y_tiles || \
       end_x < 0 || end_y < 0 || end_x >= grid.x_tiles || end_y >= grid.y_tiles):
        return null

    var start_tile = grid.get_tile(start_x, start_y)
    var end_tile := grid.get_tile(end_x, end_y)

    if(end_tile.is_solid):
        return null
 
    var start_node = NodeAstar.new({
            "tile": start_tile
        })
    var end_node = NodeAstar.new({
            "tile": end_tile,
        })

    # print("start x y = ", start_x, ", ", start_y )
    # print("end x y = ", end_x, ", ", end_y )
    
    #TODO: handle nodes for more than 1 scenario. Current implementation is for flying units only
    node_grid.set_value(start_node, start_node.x, start_node.y)
    node_grid.set_value(end_node, end_node.x, end_node.y)
    start_node.h = PolarAstarUtils.calculate_distance(start_tile, end_tile)
    
    var open_list: Array[NodeAstar] = [start_node]
    var closed_list: Array[NodeAstar] = []

    while (open_list.size() > 0):
        # get lowest F cost node and mark it as current
        var current_node: NodeAstar = open_list.reduce(get_lowest_f_cost_node, null)
        
        if(current_node == end_node):
            return PolarAstarUtils.calculate_path(current_node)
        
        open_list.erase(current_node)
        closed_list.append(current_node)
        
        var current_tile := current_node.tile
        var neighbor_tiles = current_tile.get_neighbors(grid, character_config)

        var cached_current_node = node_grid.get_value(current_node.x, current_node.y)
        if(!cached_current_node):
            print("current node was not cached ")
            node_grid.set_value(current_node, current_node.x, current_node.y)
        
        var neighbor_nodes = current_node.neighbors if current_node.neighbors else []

        # caching neighbor nodes
        if(!neighbor_nodes):
            for neighbor_tile in neighbor_tiles:
                var cached_neighbor_node = node_grid.get_value(neighbor_tile.x, neighbor_tile.y)
                if(closed_list.has(cached_neighbor_node)):
                    continue
                var neighbor_node: NodeAstar = cached_neighbor_node if cached_neighbor_node else null
                if(!neighbor_node):
                    neighbor_node = NodeAstar.new({
                        "tile": neighbor_tile,
                    })
                    node_grid.set_value(neighbor_node, neighbor_node.x, neighbor_node.y)
                
                current_node.neighbors.append(neighbor_node)
            neighbor_nodes = current_node.neighbors

        for neighbor_node in neighbor_nodes:
            if(neighbor_node.tile.is_solid && !neighbor_node.tile.is_slope):
                continue
            
            var is_in_open_list = open_list.has(neighbor_node)
            # checking if g cost is less when re-visiting this node
            var cost_to_neighbor = current_node.g + PolarAstarUtils.calculate_distance(current_tile, neighbor_node.tile)
            if(!is_in_open_list || cost_to_neighbor < neighbor_node.g):
                neighbor_node.g = cost_to_neighbor
                neighbor_node.previous_node = current_node
                if(!is_in_open_list):
                    neighbor_node.h = PolarAstarUtils.calculate_distance(neighbor_node.tile, end_tile)
                    open_list.append(neighbor_node)
                    
    return null
