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
static func can_fit_in_tile(tile: TileAstar, grid: GridAstar, character_config: PolarCharacterConfig) -> bool:
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

static func get_neighbors_flying(parameters: Dictionary):
    var down_tile = parameters.down_tile
    var up_tile = parameters.up_tile
    var left_tile = parameters.left_tile
    var right_tile = parameters.right_tile

    var up_right_tile = parameters.up_right_tile
    var up_left_tile = parameters.up_left_tile
    var down_left_tile = parameters.down_left_tile
    var down_right_tile = parameters.down_right_tile

    var tile = parameters.tile
    var grid = parameters.grid
    var character_config = parameters.character_config

    var neighbors: Array[TileAstar] = []

    if(tile.x > 0):
        # left - horizontal
        if(left_tile && \
          can_fit_in_tile(left_tile, grid, character_config)):
            neighbors.append(left_tile)
        
        # left - up
        if(up_left_tile && \
          !left_tile.is_solid && !up_tile.is_solid && \
          can_fit_in_tile(up_left_tile, grid, character_config)
        ):
            neighbors.append(up_left_tile)
        
        # left - down (slope)
        if(down_left_tile && \
            !left_tile.is_solid && \
            can_fit_in_tile(down_left_tile, grid, character_config)
          ):
            neighbors.append(down_left_tile)

    if(tile.x < grid.x_tiles - 1):
        # right - horizontal
        if(right_tile && can_fit_in_tile(right_tile, grid, character_config)):
            neighbors.append(right_tile)
        
        # right - up
        if(up_right_tile && \
            !right_tile.is_solid && !up_tile.is_solid && \
            can_fit_in_tile(up_right_tile, grid, character_config)
        ):
            neighbors.append(up_right_tile)
        
        # right - down (slopes)
        if(down_right_tile && \
            !right_tile.is_solid && !down_tile.is_solid && \
            can_fit_in_tile(down_right_tile, grid, character_config)
          ):
            neighbors.append(down_right_tile)

    # category - up & down
    if(down_tile && can_fit_in_tile(down_tile, grid, character_config)):
        neighbors.append(down_tile)
    
    if(up_tile && can_fit_in_tile(up_tile, grid, character_config)):
        neighbors.append(up_tile)

    return neighbors

static func get_neighbors_grounded(parameters: Dictionary):
    var down_tile = parameters.down_tile
    var up_tile = parameters.up_tile
    var left_tile = parameters.left_tile
    var right_tile = parameters.right_tile

    var up_right_tile = parameters.up_right_tile
    var up_left_tile = parameters.up_left_tile
    var down_left_tile = parameters.down_left_tile
    var down_right_tile = parameters.down_right_tile

    var tile = parameters.tile
    var grid = parameters.grid
    var character_config = parameters.character_config

    var neighbors: Array[TileAstar] = []

    if(tile.x > 0):
        # category: Left
        var is_left_tile_grounded = get_on_ground(left_tile, grid)

        # left - horizontal
        if(left_tile && is_left_tile_grounded && \
          can_fit_in_tile(left_tile, grid, character_config)):
            neighbors.append(left_tile)
        
        # left - up
        if(up_left_tile && \
          tile.is_slope && \
          !up_tile.is_solid && left_tile.is_solid && \
          can_fit_in_tile(up_left_tile, grid, character_config)
        ):
            neighbors.append(up_left_tile)
        
        # left - down (slope)
        if(down_left_tile && \
            down_left_tile.is_slope && \
            !left_tile.is_solid && \
            can_fit_in_tile(down_left_tile, grid, character_config)
          ):
            neighbors.append(down_left_tile)

    if(tile.x < grid.x_tiles - 1):
        # category: Right
        var is_right_tile_grounded = get_on_ground(right_tile, grid)

        # right - horizontal
        if(right_tile && is_right_tile_grounded && \
            can_fit_in_tile(right_tile, grid, character_config)):
            neighbors.append(right_tile)
        
        # right - up
        if(up_right_tile && \
            tile.is_slope && \
            right_tile.is_solid && !up_tile.is_solid && \
            can_fit_in_tile(up_right_tile, grid, character_config)
        ):
            neighbors.append(up_right_tile)
        
        # right - down (slopes)
        if(down_right_tile && \
            down_right_tile.is_slope && \
            !right_tile.is_solid && \
            can_fit_in_tile(down_right_tile, grid, character_config)
          ):
            neighbors.append(down_right_tile)

    return neighbors

# get_neighbor Y is similar to Godot. -Y means up, +Y means down. This is because grid_scanner scans from top left to bottom right
static func get_neighbors(tile: TileAstar, grid: GridAstar, character_config: PolarCharacterConfig) -> Array[TileAstar]:
    var is_flying = character_config.is_flying
    var is_grounded = get_on_ground(tile, grid)

    var down_tile = grid.get_tile(tile.x, tile.y + 1)
    var up_tile = grid.get_tile(tile.x, tile.y - 1)
    var left_tile = grid.get_tile(tile.x - 1, tile.y)
    var right_tile = grid.get_tile(tile.x + 1, tile.y)
    
    var up_right_tile = grid.get_tile(tile.x + 1, tile.y - 1)
    var up_left_tile = grid.get_tile(tile.x - 1, tile.y - 1)
    var down_left_tile = grid.get_tile(tile.x - 1, tile.y + 1)
    var down_right_tile = grid.get_tile(tile.x + 1, tile.y + 1)

    var parameters = {
        "down_tile": down_tile,
        "up_tile": up_tile,
        "left_tile": left_tile,
        "right_tile": right_tile,
        "up_right_tile": up_right_tile,
        "up_left_tile": up_left_tile,
        "down_left_tile": down_left_tile,
        "down_right_tile": down_right_tile,
        "tile": tile,
        "grid": grid,
        "character_config": character_config,
    }

    var neighbors: Array[TileAstar] = get_neighbors_flying(parameters) if is_flying else get_neighbors_grounded(parameters)
    return neighbors


static func get_on_ground(tile: TileAstar, grid: GridAstar) -> bool:
    return tile.y >= 1 && grid.get_tile(tile.x, tile.y - 1).is_solid
