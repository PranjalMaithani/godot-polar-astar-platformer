const GridAstar = preload("./grid_astar.gd")

var is_solid: bool = false
var is_slope: bool = false
var position: Vector2 # cache position
var x
var y
var neighbors # caching neighbours
var metadata: Dictionary

enum OneWayDirection { UP }
var one_way_direction: OneWayDirection

func _init(properties: Dictionary):
    is_solid = properties.is_solid
    is_slope = properties.is_slope
    position = properties.position
    x = properties.x
    y = properties.y

func get_neighbors(grid: GridAstar):
    if(neighbors):
        return neighbors
    var updated_neighbors = PolarAstarUtils.get_neighbors(self, grid)
    neighbors = updated_neighbors
    return neighbors
