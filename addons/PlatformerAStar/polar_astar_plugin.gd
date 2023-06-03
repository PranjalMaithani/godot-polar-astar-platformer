@tool
extends EditorPlugin
class_name PolarAstarPlugin

var plugin

func _enter_tree():
    plugin = preload("EditorPlugin/grid_scanner_inspector.gd").new()
    print("tryna plugin ", plugin)
    add_inspector_plugin(plugin)

func _exit_tree():
    remove_inspector_plugin(plugin)
