extends RefCounted

const NodeAstar = preload("./node_astar.gd")

var metadata: Dictionary
var is_on_slope
var position

func _init(node: NodeAstar):
    metadata = node.tile.metadata
    is_on_slope = node.tile.is_slope
    position = node.position
