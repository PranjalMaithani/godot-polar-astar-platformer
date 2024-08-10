extends RefCounted

var grid: Array = []
var grid_width: int
var grid_height: int

func _init(grid_width, grid_height):
    self.grid_width = grid_width
    self.grid_height = grid_height
    for i in grid_width:
        var column_array = []
        for j in grid_height:
            column_array.append(null)
        grid.append(column_array)

func set_value(value, x: int, y: int):
    grid[x][y] = value

func get_value(x: int, y: int):
    if(x < 0 || y < 0 || x >= grid_width || y >= grid_height):
        return null

    return grid[x][y]

func reset_values(reset_value):
    for x in grid_width:
        var column_array = []
        for y in grid_height:
            var previous_value = grid[x][y]
            if(previous_value && previous_value.has_method("queue_free")):
                previous_value.queue_free()
            grid[x][y] = reset_value;

func foreach(method: Callable):
    for x in grid_width:
        var column_array = []
        for y in grid_height:
            method.call(grid[x][y]);
