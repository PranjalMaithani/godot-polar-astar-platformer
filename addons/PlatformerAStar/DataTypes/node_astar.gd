extends Node2D
const GridAstar = preload("./grid_astar.gd")

var g: int
var h: int
var f: int:
    get: return g + h
var tile: GridAstar
