@tool
extends Node2D
class_name PolarGridScanner

const TileAstar = preload("./DataTypes/tile_astar.gd")
const GridAstar = preload("./DataTypes/grid_astar.gd")

@export_group("Tilemap")
## Specify only if you are using the Godot Tilemap
@export var tilemap: TileMap
## tilemap layers to check for custom data
@export var tilemap_layer : int = 0

@export_group("Non tilemap grid")
## Bottom right corner of the grid
@export var grid_end: Vector2 : set = _set_grid_end
## if using a tilemap, cell size is automatically picked from tilemap
@export var cell_size: float

@export_group("Collision Parameters")
## cell size ratio used when scanning for tiles
@export_range(0.2, 1.0) var cell_size_ratio: float = 1.0
## Physics layer that all obstacle tiles will have
@export_flags_2d_physics var tile_layer: int

@export_group("Visualization")
@export var show_grid: bool : set = _set_show_grid
@export var show_grid_area: bool = true : set = _set_show_grid_area
@export var grid_color: Color = Color(0.45, 0.45, 0.45, 1.0) : set = _set_grid_color 
@export var grid_solid_color: Color = Color(0.0, 1.0, 0.0, 0.2) : set = _set_grid_solid_color

var is_scanned: bool
var grid : GridAstar

func _ready():
    if(!grid):
        await get_tree().create_timer(1).timeout
        scan_grid()

func draw_grid():
    if(!grid):
        return

    # Bounds
    var grid_bounds = get_grid_bounds()
    var grid_bounds_size = grid_bounds.end_position - grid_bounds.start_position
    var grid_bounds_rect = Rect2(to_local(grid_bounds.start_position), grid_bounds_size)
    draw_rect(grid_bounds_rect, grid_color, false, 1.0)

    # Tiles
    for x in grid.x_tiles:
        for y in grid.y_tiles:
            var tile = grid.get_tile(x,y)
            if(!tile):
                continue
            var cell_offset = (1 - cell_size_ratio) * cell_size/2
            var tile_rect_size = Vector2(cell_size * cell_size_ratio, cell_size * cell_size_ratio)
            var tile_rect_start = grid_bounds.start_position + Vector2(x,y) * cell_size + Vector2(cell_offset, cell_offset)

            var tile_rect = Rect2(to_local(tile_rect_start), tile_rect_size)
            var draw_solid = tile.is_solid && show_grid_area
            var tile_color = grid_solid_color if draw_solid else grid_color
            # to prevent debugger from getting warnings noise for - width has no effect when draw_solid is true
            if(draw_solid):
                draw_rect(tile_rect, tile_color, draw_solid)
            else:
                draw_rect(tile_rect, tile_color, draw_solid, 0.5)

func _draw():
    # if !Engine.is_editor_hint():
    #     return

    if(show_grid):
        var grid_bounds = get_grid_bounds()
        draw_grid()

func _set_show_grid(value):
    show_grid = value
    queue_redraw()

func _set_show_grid_area(value):
    show_grid_area = value
    queue_redraw()

func _set_grid_end(value):
    grid_end = value
    queue_redraw()

func _set_grid_color(value):
    grid_color = value
    queue_redraw()

func _set_grid_solid_color(value):
    grid_solid_color = value
    queue_redraw()

func get_grid_bounds() -> Dictionary:
    if tilemap:
        var tilemap_rect = tilemap.get_used_rect()
        var tilemap_cell_size = tilemap.tile_set.tile_size.x #assuming tiles to be in square ratio
        var start_position := Vector2(tilemap_rect.position * tilemap_cell_size)
        var end_position := Vector2(tilemap_rect.end * tilemap_cell_size)
        return {
            "start_position": start_position,
            "end_position": end_position,
        }
    
    return {
        "start_position": position,
        "end_position": grid_end,
    }

func get_number_of_tiles_tilemap():
    var tilemap_rect = tilemap.get_used_rect()
    var x_tiles = tilemap_rect.size.x
    var y_tiles = tilemap_rect.size.y
    return {  
        "x": x_tiles,
        "y": y_tiles,
    }

func get_number_of_tiles_terrain():
    return PolarAstarUtils.get_number_of_tiles(position, grid_end, cell_size)

func scan_grid():
    if(tilemap):
        cell_size = tilemap.tile_set.tile_size.x #assuming tiles to be in square ratio
    
    var grid_bounds := get_grid_bounds()
    var start_position = grid_bounds.start_position
    var end_position = grid_bounds.end_position
    var direct_space_state := get_world_2d().direct_space_state

    var number_of_tiles = get_number_of_tiles_tilemap() if tilemap else get_number_of_tiles_terrain()
    var x_tiles = number_of_tiles.x
    var y_tiles = number_of_tiles.y
    var grid_origin = grid_bounds.start_position if tilemap else position
    grid = GridAstar.new(x_tiles, y_tiles, cell_size, position)

    var shape_parameters := PhysicsShapeQueryParameters2D.new()
    
    for x in x_tiles:
        for y in y_tiles:
            # TODO: evaluate if using tags would be better instead of mask
            var tile_position = start_position + (Vector2(x, y) * cell_size) # up left corner of tile
            var tile_center = tile_position + Vector2(cell_size/2, cell_size/2)
            
            shape_parameters.transform.origin = tile_center # since rectangle shape 2d size is considered from center
            shape_parameters.collide_with_bodies = true
            shape_parameters.collision_mask = tile_layer
            var rectangle_shape = RectangleShape2D.new()
            rectangle_shape.size = Vector2(cell_size * cell_size_ratio, cell_size * cell_size_ratio)
            shape_parameters.shape = rectangle_shape
            var shape_hit = direct_space_state.get_rest_info(shape_parameters)

            var is_solid = shape_hit.size() > 0
            # if(is_solid):
            #     print("found solid at ", tile_center, " for  XY = ", x, ", ", y)
            var is_slope = false
            var tile_properties = {
                "is_solid": is_solid,
                "is_slope": is_slope,
                "position": tile_center,
                "x": x,
                "y": y,
            }
            var tile: TileAstar = TileAstar.new(tile_properties)
            grid.set_tile(tile, x, y)
    
    queue_redraw()

func get_pathfinding_grid() -> GridAstar:
    return grid
