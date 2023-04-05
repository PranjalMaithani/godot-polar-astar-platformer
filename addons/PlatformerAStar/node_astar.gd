extends Node2D
class_name polar_node_astar_2d

var g: int
var h: int
var f: int:
    get: return g + h
var connection: polar_node_astar_2d
var tile: polar_tile_astar_2d