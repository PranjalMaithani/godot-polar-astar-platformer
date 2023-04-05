extends Camera2D

@export var lerp_speed = 3.0
@export var target_path: NodePath

var target: Node2D = null

func _ready():
	if target_path:
		target = get_node(target_path)

func _physics_process(delta):
	if !target:
		return
	
	position = position.lerp(target.position, lerp_speed * delta)
	