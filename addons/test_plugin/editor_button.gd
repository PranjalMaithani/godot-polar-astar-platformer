extends HBoxContainer

var button = Button.new()

func _init(properties: Dictionary):
    var callback = properties.callback
    var text = properties.text
    button.text = text
    button.size_flags_horizontal = SIZE_EXPAND_FILL
    add_child(button)
    button.connect("pressed", callback)
