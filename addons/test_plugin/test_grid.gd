@tool
class_name TestGrid
extends Node2D
@export var tilemap: TileMap
@export_flags_2d_physics var tile_layer: int

func _draw():
    pass

func print_grid_position():
    print(transform.origin)

func print_grid_bounds():
    # doesn't take transform position into account
    # rect bounds considers parent transform origin as its origin
    var tilemap_rect = tilemap.get_used_rect()
    # top left
    var start_positon = tilemap_rect.position
    # bottom right
    var end_position = tilemap_rect.end
    var tiles_count = PolarAstarUtils.get_number_of_tiles(start_positon, end_position, 1)

func check_rect_collision():
    var shape_parameters := PhysicsShapeQueryParameters2D.new()
    var direct_space_state := get_world_2d().direct_space_state

    shape_parameters.collide_with_bodies = true
    # TODO: check if using tags would be better instead of mask
    shape_parameters.collision_mask = tile_layer
    var rectangle_shape = RectangleShape2D.new()
    rectangle_shape.size = Vector2(1, 1)
    shape_parameters.shape = rectangle_shape
    var shape_hit = direct_space_state.get_rest_info(shape_parameters)

    var is_solid = shape_hit.size() > 0