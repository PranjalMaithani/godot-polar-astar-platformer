extends CharacterBody2D


@export var SPEED = 200.0
@export var JUMP_VELOCITY = -350.0

@onready var player_sprite: AnimatedSprite2D = %PlayerSprite

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass 

func _physics_process(delta):
	handle_movement(delta)
	handle_animation()
	handle_sprite_direction()
	move_and_slide()

func handle_animation():
	if(velocity.y != 0):
		player_sprite.play("jump")
		return
		
	if(abs(velocity.x) > 0):
		player_sprite.play("run")
	else:
		player_sprite.play("idle")

func handle_sprite_direction():
	if(velocity.x > 0):
		player_sprite.flip_h = false
	elif(velocity.x < 0):
		player_sprite.flip_h = true

func handle_movement(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_released("ui_accept") and velocity.y < 0:
		velocity.y *= 0.6

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
