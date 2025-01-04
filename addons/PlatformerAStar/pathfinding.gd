@tool
extends Node
class_name PolarPathfinding

const Array2d = preload("./DataTypes/array2d.gd")
const NodeAstar = preload("./DataTypes/node_astar.gd")
const TileAstar = preload("./DataTypes/tile_astar.gd")
const GridAstar = preload("./DataTypes/grid_astar.gd")
const PathfindingNode = preload("./DataTypes/pathfinding_node.gd")
const GridScanner = preload("./grid_scanner.gd")

@export var grid_scanner: GridScanner

var is_throttled = false
@onready var throttle_timer: Timer = $ThrottleTimer

var grid: GridAstar
var node_grid: Array2d
var character_config: Dictionary = {
    "name": "default",
    "flying": true,
    "size": Vector2(1,1)
} #TODO: create character config resource class

var path: Array[PathfindingNode] = []
var is_initialized = false

func enable_pathfinding():
  is_throttled = false

func _ready():
    await get_tree().create_timer(1).timeout
    grid = grid_scanner.get_pathfinding_grid()
    node_grid = Array2d.new(grid.x_tiles, grid.y_tiles)
    grid.grid_array2d.foreach(func(tile):
      var node = NodeAstar.new({
        "tile": tile
      })
      node_grid.set_value(node, tile.x, tile.y)
    )
    grid.grid_array2d.foreach(func(tile):
      var tile_neighbors = tile.get_neighbors(character_config)
      #TODO: check if there is a more optimized way to do this
      for tile_neighbor in tile_neighbors:
        node_grid.get_value(tile.x, tile.y).neighbors.append(node_grid.get_value(tile_neighbor.x, tile_neighbor.y))
    )
    throttle_timer.timeout.connect(enable_pathfinding)
    is_initialized = true

func get_lowest_f_cost_node(prev: NodeAstar, current: NodeAstar):
    if(prev == null):
        return current
    if(current.f < prev.f || (current.f == prev.f && current.h < prev.h)):
        return current
    return prev

func find_path(parameters: Dictionary):
    if(!is_initialized || is_throttled):
      return

    is_throttled = true
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

    var start_node = node_grid.get_value(start_x, start_y)
    var end_node = node_grid.get_value(end_x, end_y)

    if(end_node.tile.is_solid):
        return null

    #TODO: handle nodes for more than 1 scenario. Current implementation is for flying units only
    node_grid.set_value(start_node, start_node.x, start_node.y)
    node_grid.set_value(end_node, end_node.x, end_node.y)
    start_node.h = PolarAstarUtils.calculate_tile_distance(grid.cell_size, start_node.tile, end_node.tile)
    
    var open_list: Array[NodeAstar] = [start_node]
    var closed_list: Array[NodeAstar] = []

    while (open_list.size() > 0):        
        # get lowest F cost node and mark it as current
        var current_node: NodeAstar = open_list.reduce(get_lowest_f_cost_node, null)
        
        if(current_node == end_node):
            path = PolarAstarUtils.calculate_path(current_node)
            return path
        
        open_list.erase(current_node)
        closed_list.append(current_node)
        
        var current_tile := current_node.tile
        var neighbor_nodes = current_node.neighbors
        for neighbor_node in neighbor_nodes:
            if(closed_list.has(neighbor_node)):
                continue
            if(neighbor_node.tile.is_solid && !neighbor_node.tile.is_slope):
                continue
            
            var is_in_open_list = open_list.has(neighbor_node)
            # checking if g cost is less when re-visiting this node
            var cost_to_neighbor = current_node.g + PolarAstarUtils.calculate_tile_distance(grid.cell_size, current_tile, neighbor_node.tile)
            if(!is_in_open_list || cost_to_neighbor < neighbor_node.g):
                neighbor_node.g = cost_to_neighbor
                neighbor_node.previous_node = current_node
                if(!is_in_open_list):
                    neighbor_node.h = PolarAstarUtils.calculate_tile_distance(grid.cell_size, neighbor_node.tile, end_node.tile)
                    open_list.append(neighbor_node)
                    
    return null
