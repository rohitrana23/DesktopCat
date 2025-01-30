extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var mousePos = Vector2()
var move

func _ready():
	move = false
	get_tree().get_root().set_transparent_background(true)
	

func _physics_process(delta):
	
	if move == true:
		$AnimatedSprite2D.play("running")
	else:
		$AnimatedSprite2D.play("standing")
	print(mousePos)
	if Input.is_action_just_pressed("lmb"):
		mousePos = get_global_mouse_position()
		move = true
	if move == true:
		velocity = Vector2.ZERO
		velocity = position.direction_to(mousePos) * SPEED * 2
		if position.distance_to(mousePos) < 5:
			move = false
			Vector2.ZERO

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	if velocity.x < 0:
		$AnimatedSprite2D.scale.x = 2.857
	elif velocity.x > 0:
		$AnimatedSprite2D.scale.x = -2.857
	if velocity.x == 0:
		$AnimatedSprite2D.scale.x = 2.857

  

