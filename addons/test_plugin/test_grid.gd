@tool
class_name TestGrid
extends Node2D
@export var tilemap: TileMap
@export var check_node: Node2D
@export_flags_2d_physics var tile_layer: int

func _draw():
    print("fixed rect pos = ", check_node.position)
    print("fixed to local = ", to_local(Vector2(0,0)))
    var fixed_rect = Rect2(to_local(check_node.position), Vector2(16,16))
    draw_rect(fixed_rect, Color.DARK_RED, false, 3.0)

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
    print("start ",start_positon)
    print("end ", end_position)
    var tiles_count = PolarAstarUtils.get_number_of_tiles(start_positon, end_position, 1)
    print("number of X tiles = ", tiles_count.x)
    print("number of Y tiles = ", tiles_count.y)

func check_rect_collision():
    var tile_positon = check_node.position
    var shape_parameters := PhysicsShapeQueryParameters2D.new()
    var direct_space_state := get_world_2d().direct_space_state

    shape_parameters.transform.origin = tile_positon
    shape_parameters.collide_with_bodies = true
    # TODO: check if using tags would be better instead of mask
    shape_parameters.collision_mask = tile_layer
    var rectangle_shape = RectangleShape2D.new()
    rectangle_shape.size = Vector2(1, 1)
    shape_parameters.shape = rectangle_shape
    var shape_hit = direct_space_state.get_rest_info(shape_parameters)

    var is_solid = shape_hit.size() > 0
    print("is solid at tile = ",is_solid)