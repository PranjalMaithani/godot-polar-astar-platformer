extends Resource
class_name PolarTileAstar2d

var is_solid: bool = false
var is_slope: bool = false
var position: Vector2 # cache position
var neighbours # caching neighbours

enum OneWayDirection { UP }
var one_way_direction: OneWayDirection

func _init(properties: Dictionary):
    is_solid = properties.is_solid
    is_slope = properties.is_slope
    position = properties.position

func set_neighbors(value):
    neighbours = value