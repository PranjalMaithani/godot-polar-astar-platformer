class_name PolarAstarUtils

const NodeAstar = preload("./DataTypes/node_astar.gd")
const PathfindingNode = preload("./DataTypes/pathfinding_node.gd")
const TileAstar = preload("./DataTypes/tile_astar.gd")
const GridAstar = preload("./DataTypes/grid_astar.gd")

static func calculate_tile_distance(tile_size, first_tile: TileAstar, second_tile: TileAstar):
  var x_distance = abs(first_tile.position.x - second_tile.position.x) / tile_size
  var y_distance = abs(first_tile.position.y - second_tile.position.y) / tile_size
  var lowest = min(x_distance, y_distance)
  var highest = max(x_distance, y_distance)
  var horizontal_moves_required = highest - lowest
  return lowest * 14 + horizontal_moves_required * 10

static func get_number_of_tiles(start_position: Vector2, end_position: Vector2, cell_size: float):
    var x_tiles := floor(abs(end_position.x - start_position.x)/cell_size)
    var y_tiles := floor(abs(end_position.y - start_position.y)/cell_size)
    return {  
        "x": x_tiles,
        "y": y_tiles,
    }

# Temporary fix as nodes are being returned as null in tool scripts in Godot 4
# https://github.com/godotengine/godot/issues/74141
static func load_editor_values(obj : Object) -> void:
    for meta in obj.get_meta_list():
        if meta.begins_with("_editor_prop_ptr_"):
            var prop_name = meta.trim_prefix("_editor_prop_ptr_")
            var prop_value = obj.get_meta(meta)
            if prop_value is NodePath:
                obj.set(prop_name, obj.get_node(prop_value))
            else:
                push_error("unknown type:", prop_value)

static func calculate_path(path_end_node: NodeAstar) -> Array[PathfindingNode]:
    var path: Array[PathfindingNode] = []
    var end_node = PathfindingNode.new(path_end_node)
    path.append(end_node)
    var current_node: NodeAstar = path_end_node
    while(current_node.previous_node):
        var previous_node = PathfindingNode.new(current_node.previous_node)
        path.append(previous_node)
        current_node = current_node.previous_node
    path.reverse()
    return path

## Consider range from bottom-left to top-right
static func can_move_to_tile(tile: TileAstar, grid: GridAstar, character_config: PolarCharacterConfig) -> bool:
    var is_out_of_bounds = tile.x + character_config.size.x > grid.x_tiles - 1 || tile.y + character_config.size.y > grid.y_tiles - 1
    if(is_out_of_bounds):
      return false

    var width = character_config.size.x
    var height = character_config.size.y
    for x in width:
      for y in height:
        var current_tile = grid.get_tile(tile.x + x, tile.y + y)
        if(current_tile.is_solid):
          return false
    return true

# get_neighbor Y is similar to Godot. -Y means up, +Y means down. This is because grid_scanner scans from top left to bottom right
static func get_neighbors(tile: TileAstar, grid: GridAstar, character_config: PolarCharacterConfig) -> Array[TileAstar]:
    #TODO: handle for different sized characters
    var neighbors: Array[TileAstar] = []
    var is_flying = character_config.is_flying
    var is_grounded = get_on_ground(tile, grid)

    var down_tile = grid.get_tile(tile.x, tile.y + 1)
    var up_tile = grid.get_tile(tile.x, tile.y - 1)
    var up_right_tile = grid.get_tile(tile.x + 1, tile.y - 1)
    var up_left_tile = grid.get_tile(tile.x - 1, tile.y - 1)
    var down_left_tile = grid.get_tile(tile.x - 1, tile.y + 1)
    var down_right_tile = grid.get_tile(tile.x + 1, tile.y + 1)

    if(tile.x > 0):
        # category: Left
        var left_tile = grid.get_tile(tile.x - 1, tile.y)
        var is_left_tile_grounded = get_on_ground(left_tile, grid)

        # left - horizontal
        if(left_tile && (is_left_tile_grounded || is_flying) && \
          can_move_to_tile(left_tile, grid, character_config)):
            neighbors.append(left_tile)
        
        # left - up
        if(up_left_tile && \
          !left_tile.is_solid && !up_tile.is_solid && \
          can_move_to_tile(up_left_tile, grid, character_config)
        ):
            neighbors.append(up_left_tile)
        
        # left - down (slope)
        if(down_left_tile && \
            (is_flying || down_left_tile.is_slope) && \
            !left_tile.is_solid && \
            can_move_to_tile(down_left_tile, grid, character_config)
          ):
            neighbors.append(down_left_tile)

    if(tile.x < grid.x_tiles - 1):
        # category: Right
        var right_tile = grid.get_tile(tile.x + 1, tile.y)
        var is_right_tile_grounded = get_on_ground(right_tile, grid)

        # right - horizontal
        if(right_tile && (is_right_tile_grounded || is_flying) && can_move_to_tile(right_tile, grid, character_config)):
            neighbors.append(right_tile)
        
        # right - up
        if(up_right_tile && \
            !right_tile.is_solid && !up_tile.is_solid && \
            can_move_to_tile(up_right_tile, grid, character_config)
        ):
            neighbors.append(up_right_tile)
        
        # right - down (slopes)
        if(down_right_tile && \
            (is_flying || down_right_tile.is_slope) && \
            !right_tile.is_solid && \
            can_move_to_tile(down_right_tile, grid, character_config)
          ):
            neighbors.append(down_right_tile)

    # category - up & down
    if(is_flying && down_tile && can_move_to_tile(down_tile, grid, character_config)):
        neighbors.append(down_tile)
    
    if(is_flying && up_tile && can_move_to_tile(up_tile, grid, character_config)):
        neighbors.append(up_tile)

    return neighbors


static func get_on_ground(tile: TileAstar, grid: GridAstar) -> bool:
    return tile.y >= 1 && grid.get_tile(tile.x, tile.y - 1).is_solid
