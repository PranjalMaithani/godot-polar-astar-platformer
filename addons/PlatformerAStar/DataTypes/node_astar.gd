extends Node2D
class_name PolarNodeAstar2d

var g: int
var h: int
var f: int:
    get: return g + h
var connection: PolarNodeAstar2d
var tile: PolarGridAstar