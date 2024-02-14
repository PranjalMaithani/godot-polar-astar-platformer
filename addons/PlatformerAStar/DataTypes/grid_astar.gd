extends RefCounted

const Array2d = preload("./array2d.gd")
const TileAstar = preload("./tile_astar.gd")
# const PolarArray2d = preload("res://addons/PlatformerAStar/DataTypes/array2d.gd")
## number of cells in X axis
var x_tiles: int
## number of cells in Y axis
var y_tiles: int
var cell_size: float
var origin_position: Vector2

var grid_array2d: Array2d

## origin is at top left corner of the grid. The grid spans to the right and downwards
func _init(x_tiles: int, y_tiles: int, cell_size: int, origin_position: Vector2):
    self.x_tiles = x_tiles
    self.y_tiles = y_tiles
    self.cell_size = cell_size
    self.origin_position = origin_position
    grid_array2d = Array2d.new(x_tiles, y_tiles)

func set_tile(tile: TileAstar, x: int, y: int):
    grid_array2d.set_value(tile, x, y)

func get_tile(x: int, y: int) -> TileAstar:
    return grid_array2d.get_value(x,y)

func get_xy_from_position(position):
    var x = floori((position.x - origin_position.x)/cell_size)
    var y = floori((position.y - origin_position.y)/cell_size)
    return {
        "x": x,
        "y": y,
    }
