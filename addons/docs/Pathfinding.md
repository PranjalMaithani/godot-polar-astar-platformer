# Pathfinding

- grid = reference to pathfinding grid (got after scanning using grid scanner)
- node_grid = 2D array with reference to Node astars

- Take start and end positions
- Get grid X Y positions for both
- If out of bounds or end_tile is solid, return null
- Start node & End node -> NodeAstar.new(from tiles)
- Node grid -> set start and end nodes
- Calculate start node h cost

Main pathfinding logic starts here
- Open list = `[start_node]`
- Closed list = `[]`

- while(open list size > 0) keep running below logic until current node is end_node
- current node = get lowest F cost node from open list
- if current node = end node, calculate path and return. Queue_free start and end nodes (TODO: what about other nodes?? Should it be directly free since these are not added to scene tree)
- Remove current node from open list and add it to closed list
- Get current tile and its neighbors

- Check cached current node(lowest f cost) if present in node_grid. If not set it there
- neighbor nodes = current node neighbors or []

// setting current node neighbors <TODO: seems suspicious code leak>
- if no neighbor node ([]) 
  - for each neighbor tile
    - cached neighbor node = node_grid(node at neighbor tile position)
    - if cached node present in closed list, skip this neighbor tile
    - else if no cached neighbor node, create neighbor node and set at node_grid(n.tile position)
    - finally append this node to current_node neighhbors
  - set neighbor nodes = current_node neighbors

// A star logic here:
- for each neighbor node now
  - if is solid and not slope continue. END.
  - get cost to neighbor node = current G + distance from current tile to n.Node tile
  - if is not in open list or cost to neighbor < n.Node.G (found a better route to this node)
  - n.node G = cost to neighbor, n.Node previous = current
  - if not in open list, calc n.Node H cost and add n.Node open list

^ Repeat pathfinding process
