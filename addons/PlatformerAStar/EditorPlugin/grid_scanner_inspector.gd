extends EditorInspectorPlugin

var EditorButton = preload("editor_button.gd")

func _can_handle(object):
    if(object is PolarGridScanner):
        return true

func _parse_begin(object):
    # to ensure tilemap is not null due to godot bug
    PolarAstarUtils.load_editor_values(object)

    var scan_grid = (object as PolarGridScanner).scan_grid
    var vbox: VBoxContainer = VBoxContainer.new()
    vbox.add_child(EditorButton.new({
        "text": "Scan Grid",
        "callback": scan_grid
        }))
    vbox.add_spacer(false)

    add_custom_control(vbox)
