class_name polar_astar_utils

static func calculate_distance(firstTile: polar_tile_astar_2d, secondTile: polar_tile_astar_2d):
    # TODO: return distance considering fall/jump in mind
    var firstVector = Vector2(firstTile.x, firstTile.y)
    var secondVector = Vector2(secondTile.x, secondTile.y)
    return firstVector.distance_to(secondVector)
