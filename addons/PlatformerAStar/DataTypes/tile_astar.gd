extends RefCounted

const GridAstar = preload("./grid_astar.gd")

var is_solid: bool = false
var is_slope: bool = false
var is_edge: bool = false
var is_wall: bool = false
var position: Vector2 # cache position
var x
var y
## caching neighbours based on character config. Neighbors can be different for flying/non-flying characters etc.
var neighbors_map: Dictionary = {} 
var metadata: Dictionary

enum OneWayDirection { UP }
var one_way_direction: OneWayDirection

func _init(properties: Dictionary):
    is_solid = properties.is_solid
    is_slope = properties.is_slope
    position = properties.position
    # is_edge = properties.is_edge
    # is_wall = properties.is_wall
    # metadata = properties.metadata

    x = properties.x
    y = properties.y

func set_neighbors(grid: GridAstar, character_config: PolarCharacterConfig):
  var updated_neighbors = PolarAstarUtils.get_neighbors(self, grid, character_config)
  neighbors_map[character_config.name] = updated_neighbors
  return updated_neighbors

func get_neighbors(character_config: PolarCharacterConfig):
    return neighbors_map[character_config.name]
