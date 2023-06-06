const TileAstar = preload("./tile_astar.gd")
const NodeAstar = preload("./node_astar.gd")

var g: int
var h: int
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
var metadata: Dictionary
var is_on_slope: bool

var neighbors: NodeAstar

func _init(properties):
    g = properties.g
    h = properties.h
    tile = properties.tile
    previous_node = properties.previous_node
