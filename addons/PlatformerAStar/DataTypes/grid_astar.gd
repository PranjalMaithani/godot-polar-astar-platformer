extends Node2D
class_name PolarGridAstar

## number of cells in X axis
var x_tiles: int
## number of cells in Y axis
var y_tiles: int
var cell_size: float
var origin_position: Vector2

var grid_array2d: PolarArray2d

## origin is at top left corner of the grid. The grid spans to the right and downwards
func _init(x_tiles: int, y_tiles: int, cell_size: int, origin_position: Vector2):
    self.x_tiles = x_tiles
    self.y_tiles = y_tiles
    self.cell_size = cell_size
    self.origin_position = origin_position
    grid_array2d = PolarArray2d.new(x_tiles, y_tiles)

func set_tile(tile: PolarTileAstar2d, x: int, y: int):
    grid_array2d.set_value(tile, x, y)

func get_tile(x: int, y: int) -> PolarTileAstar2d:
    return grid_array2d.get_value(x,y)
