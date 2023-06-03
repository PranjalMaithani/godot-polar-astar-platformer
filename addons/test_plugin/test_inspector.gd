extends EditorInspectorPlugin

var EditorButton := preload("editor_button.gd")

func _can_handle(object):
    if(object is TestGrid):
        return true

func _parse_begin(object):
    PolarAstarUtils.load_editor_values(object)
    var print_grid_position = object.print_grid_position
    var print_grid_bounds = object.print_grid_bounds
    var check_rect_collision = object.check_rect_collision
    var vbox: VBoxContainer = VBoxContainer.new()
    vbox.add_child(EditorButton.new({
        "text": "Print Grid Position",
        "callback": print_grid_position
        }))
    vbox.add_spacer(false)
    vbox.add_child(EditorButton.new({
        "text": "Print Grid Bounds",
        "callback": print_grid_bounds
    }))
    vbox.add_spacer(false)
    add_custom_control(vbox)
    vbox.add_child(EditorButton.new({
        "text": "Check collision",
        "callback": check_rect_collision
    }))
    vbox.add_spacer(false)
