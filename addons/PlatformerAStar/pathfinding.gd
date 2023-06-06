@tool
class_name PolarPathfinding

const Array2d = preload("./DataTypes/array2d.gd")
const NodeAstar = preload("./DataTypes/node_astar.gd")
const TileAstar = preload("./DataTypes/tile_astar.gd")
const GridAstar = preload("./DataTypes/grid_astar.gd")
const PathfindingNode = preload("./DataTypes/pathfinding_node.gd")

var grid: GridAstar
var node_grid: Array2d
var character_config: Dictionary #TODO: create character config resource class

func _init(parameters: Dictionary):
    grid = parameters.grid
    node_grid = Array2d.new(grid.x_tiles, grid.y_tiles)
    character_config = parameters.character_config

func find_path(parameters: Dictionary):
    var start_position = parameters.start_position
    var end_position = parameters.start_position

    var start_xy = grid.get_xy_from_position(start_position)
    var start_x = start_xy.x
    var start_y = start_xy.y
    var end_xy = grid.get_xy_from_position(end_position)
    var end_x = end_xy.x
    var end_y = end_xy.y

    # Y axis is invert in Godot
    if(start_x < 0 || start_y > 0 || end_x > grid.x_tiles || abs(end_y) > grid.y_tiles):
        return null

    var start_tile = grid.get_tile(start_x, start_y)
    var end_tile := grid.get_tile(end_x, end_y)

    if(end_tile.is_solid):
        return null
    
    var start_node = node_grid.node_array2d.get_value(start_x, start_y) || \
        NodeAstar.new({
            "g": 0,
            "h": 1,
            "tile": start_tile
        })
    var end_node = node_grid.node_array2d.get_value(end_x, end_y) || \
        NodeAstar.new({
            "g": 0,
            "h": 0,
            "tile": end_tile,
        })
    start_node.h = PolarAstarUtils.calculate_distance(start_tile, end_tile)
 
    var open_list: Array[NodeAstar] = [start_node]
    var closed_list: Array[NodeAstar] = []

    while (open_list.size() > 0):
        # get lowest F cost node and mark it as current
        var current_node = open_list.reduce(func(prev, next): return next.f < prev.f || (next.f == prev.f && next.h < prev.h))
        if(current_node == end_node):
            return PolarAstarUtils.calculate_path(current_node)
        if(closed_list.has(current_node)):
            continue
        
        open_list.erase(current_node)
        closed_list.append(current_node)
        
        var current_tile = current_node.tile
        var neighbor_tiles = current_tile.get_neighbors(grid)
        
        var neighbor_nodes = node_grid.get_value(current_node.x, current_node.y).neighbors
        # Caching neighbors in node
        if !neighbor_nodes:
            for neighbor_tile in neighbor_tiles:
                var neighbor_g_cost = PolarAstarUtils.calculate_distance(current_node, neighbor_tile)
                var neighbor_h_cost = PolarAstarUtils.calculate_distance(neighbor_tile, end_tile)
                var neighbor_node := NodeAstar.new({
                    "tile": neighbor_tile,
                    "previous_node": current_node,
                    "g": neighbor_g_cost,
                    "h": neighbor_h_cost
                })
                node_grid.set_value(neighbor_node, neighbor_node.x, neighbor_node.y)
            neighbor_nodes = node_grid.get_value(current_node.x, current_node.y).neighbors
        
        var lowest_g_cost = 9999
        for neighbor_node in neighbor_nodes:
            if(neighbor_node.tile.is_solid):
                continue
            
            var is_in_open_list = open_list.has(neighbor_node)
            # checking if g cost is less when revisiting this node
            var cost_to_neighbor = PolarAstarUtils.calculate_distance(current_tile, neighbor_node.tile)
            if(!is_in_open_list || cost_to_neighbor < neighbor_node.g):
                neighbor_node.g = cost_to_neighbor
                neighbor_node.previous_node = current_node
                if(!is_in_open_list):
                    open_list.append(neighbor_node)
