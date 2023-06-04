class_name PolarAstarUtils

const TileAstar = preload("./DataTypes/grid_astar.gd")

static func calculate_distance(first_tile: TileAstar, second_tile: TileAstar):
    # TODO: return distance considering fall/jump in mind
    var first_vector = Vector2(first_tile.x, first_tile.y)
    var second_vector = Vector2(second_tile.x, second_tile.y)
    return first_vector.distance_to(second_vector)

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
