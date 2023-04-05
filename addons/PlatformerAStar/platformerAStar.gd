@tool
extends EditorPlugin

func find_path(startNode: polar_node_astar_2d, targetNode: polar_node_astar_2d):
	var openList: Array[polar_node_astar_2d] = []
	var closedList: Array[polar_node_astar_2d] = []

	while (openList.size() > 0):
		var currentNode = openList[0];
		# get lowest F cost node and mark it as current
		currentNode = openList.reduce(func(prev, current): return current.f < prev.f)
		closedList.append(currentNode)
		openList.erase(currentNode)
		
		if(currentNode == targetNode):
			var currentPathTile = targetNode
			var path: Array[polar_node_astar_2d] = []
			var errorSafetyCount = 100
			while(currentNode != startNode):
				path.append(currentNode)
				currentNode = currentNode.connection
				errorSafetyCount -= 1
				if(errorSafetyCount < 0):
					push_error("path count is more than 100")
			
			return currentNode
		# var allowedNodes = currentNode.


func _enter_tree():
	# Initialization of the plugin goes here.
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
