extends VBoxContainer

var test_grid: TestGrid

# Called when the node enters the scene tree for the first time.
func _ready():
    var PrintPositionButton := %PrintPositionButton as Button
    %PrintPositionButton.connect("pressed", test_grid.print_grid_position)

    var GridBoundsButton := %GridBoundsButton as Button
    GridBoundsButton.connect("pressed", test_grid.print_grid_bounds)
