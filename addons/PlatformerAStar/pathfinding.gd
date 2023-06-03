@tool

func find_path(start_position: Vector3, end_position: Vector3):
	var start_node
	var target_node
	var open_list: Array[PolarNodeAstar2d] = []
	var closed_list: Array[PolarNodeAstar2d] = []

	while (open_list.size() > 0):
		var current_node = open_list[0];
		# get lowest F cost node and mark it as current
		current_node = open_list.reduce(func(prev, current): return current.f < prev.f)
		closed_list.append(current_node)
		open_list.erase(current_node)
		
		if(current_node == target_node):
			var current_path_tile = target_node
			var path: Array[PolarNodeAstar2d] = []
			var error_safety_count = 100
			while(current_node != start_node):
				path.append(current_node)
				current_node = current_node.connection
				error_safety_count -= 1
				if(error_safety_count < 0):
					push_error("path count is more than 100")
			
			return current_node
		# var allowedNodes = current_node.


func _enter_tree():
	# Initialization of the plugin goes here.
	pass


func _exit_tree():
	# Clean-up of the plugin goes here.
	pass
