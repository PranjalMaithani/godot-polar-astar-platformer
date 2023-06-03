extends Resource
class_name PolarTileAstar2d

var test_value = "HUI"
var is_solid: bool = false
var is_slope: bool = false
var position: Vector2 # cache position
var neighbours # caching neighbours

enum OneWayDirection { UP }
var one_way_direction: OneWayDirection

func _init(properties: Dictionary):
    var is_solid = properties.is_solid
    var is_slope = properties.is_slope
    test_value = "HUI HUIH UI"

func set_neighbors(value):
    neighbours = value