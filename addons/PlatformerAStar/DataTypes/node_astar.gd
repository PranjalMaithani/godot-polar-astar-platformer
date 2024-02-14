extends RefCounted

const TileAstar = preload("./tile_astar.gd")
const NodeAstar = preload("./node_astar.gd")

var g: int = 0
var h: int = 0
var f: int:
    get: return g + h
var tile: TileAstar
var x:
    get: return tile.x
var y:
    get: return tile.y
var position:
    get: return tile.position
## Previous node which connected to this node
var previous_node: NodeAstar
# TODO: check metadata and is on slope since node will get this from bottom tile instead

var neighbors: Array[NodeAstar] = []

func _init(properties):
    tile = properties.tile

func reset_values():
    g = 0
    h = 0
