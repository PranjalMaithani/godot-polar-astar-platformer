# Data Types

## Node Astar

- Pathfinding node used in astar algo. Has G,H cost and reference to previous node
- Has a reference to neighbor 
- Initialzied by passing a TileAstar

## Pathfinding Node

- Node returned in pathfinding array
- Has position and other metadata like is_slope to be used during movement
- Can have other metadata for smarter movement logic

## Tile Astar

- Tile on the tilemap which should be initialized only once per position in tilemap
- Has data on is_solid, is_slope, position and neighboring tiles
- For get_neighbors functions, either check cached results or calculate neighbors on demand and then return.
- Can optionally run this intially to save on performance
