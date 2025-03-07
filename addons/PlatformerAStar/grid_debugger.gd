@tool
extends Node2D
class_name PolarGridDebugger

const TileAstar = preload("./DataTypes/tile_astar.gd")
const GridAstar = preload("./DataTypes/grid_astar.gd")

@export var grid_scanner: PolarGridScanner
@export var selected_character_config: PolarCharacterConfig
var grid: GridAstar

func get_tile_from_position(position: Vector2) -> TileAstar:
  var xy = grid.get_xy_from_position(position)
  return grid_scanner.grid.get_tile(xy.x, xy.y)

func draw_tile_connection(tile: TileAstar, neighbor: TileAstar, properties: Dictionary):
  var tile_position = tile.position
  var neighbor_position = neighbor.position
  var color = properties.color
  var width = properties.width
  draw_line(tile_position, neighbor_position, color, width)

func _ready():
  grid = grid_scanner.grid
  
func _draw():
  var selected_tile = get_tile_from_position(get_global_mouse_position())
  if(!selected_tile):
    return
  
  var tile_neighbors = selected_tile.neighbors_map[selected_character_config.name]
  for neighbor in tile_neighbors:
    draw_tile_connection(selected_tile, neighbor, {
      "color": Color(1, 0, 0),
      "width": 2
    })
