extends CharacterBody2D

const SPEED = 175
const JUMP_VELOCITY = -400.0
@onready var pet_sprite : Sprite2D = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var mousePos = Vector2()
var move = false
var goingToRest = false
var rest = false
func _ready():
	move = false
	get_tree().get_root().set_transparent_background(true)

func _physics_process(delta):
	velocity = Vector2.ZERO  # Reset velocity each frame

	# Update mouse position every frame for movement tracking
	mousePos = get_global_mouse_position()

	
	if position.distance_to(mousePos) > 350 and goingToRest==false and rest!=true:
		move = true
	

	
	if Input.is_action_just_pressed("q"):
		get_tree().quit()
	if Input.is_action_just_pressed("rmb") and rest==false:
	 
		goingToRest = true
	if Input.is_action_just_pressed("rmb") and rest!=false:
		rest=false


	if goingToRest:
		velocity = position.direction_to(Vector2(1811, 918)) * SPEED * 2
		if position.distance_to(Vector2(1811, 918)) < 5:
			move = false
			goingToRest = false
			rest=true
	if rest==true:
		velocity=Vector2.ZERO

	if move:
		velocity = position.direction_to(mousePos) * SPEED * 2

	if position.distance_to(mousePos) < 10:
		move = false

	# Animation state
	if move or goingToRest:
		$AnimatedSprite2D.play("running")
	else:
		$AnimatedSprite2D.play("standing")

	# Flip the sprite based on movement direction
	if velocity.x < 0:
		$AnimatedSprite2D.scale.x = 2.857
	elif velocity.x > 0:
		$AnimatedSprite2D.scale.x = -2.857
	else:
		$AnimatedSprite2D.scale.x = 2.857

	move_and_slide()  # Pass velocity to move_and_slide()

func _process(delta):
	set_passthrough(pet_sprite)

func set_passthrough(sprite: Sprite2D):
	var texture_center: Vector2 = sprite.texture.get_size() / 2
	var texture_corners: PackedVector2Array = [
		sprite.global_position + texture_center * Vector2(-2, -2),
		sprite.global_position + texture_center * Vector2(2, -2),
		sprite.global_position + texture_center * Vector2(2, 2),
		sprite.global_position + texture_center * Vector2(-2, 2)
	]

	# Set mouse passthrough only for the pet's texture region
	DisplayServer.window_set_mouse_passthrough(texture_corners)

	
