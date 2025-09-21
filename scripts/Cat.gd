extends CharacterBody2D

const SPEED = 175
const JUMP_VELOCITY = -400.0

@onready var pet_sprite : Sprite2D = $Sprite2D
@onready var text = $text
@onready var animated_sprite = $AnimatedSprite2D


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var mousePos = Vector2()
var move = false
var goingToRest = false
var rest = false

var phrases = ["Stay hydrated", "Meow!", "take proper rests", "work hard"]
var current_phrase_index = 0

var text_show_timer = 0.0
var text_visible_timer = 0.0
var text_is_visible = false

func _ready():
	move = false
	get_tree().get_root().set_transparent_background(true)
	text.visible = false 

func _physics_process(delta):
	velocity = Vector2.ZERO
	mousePos = get_global_mouse_position()
	
	if position.distance_to(mousePos) > 350 and not goingToRest and not rest:
		move = true
	
	if Input.is_action_just_pressed("q"):
		get_tree().quit()
	if Input.is_action_just_pressed("rmb") and not rest:
		goingToRest = true
	if Input.is_action_just_pressed("rmb") and rest:
		rest = false

	if goingToRest:
		# Move towards a specific rest position (1811, 918)
		velocity = position.direction_to(Vector2(1811, 918)) * SPEED * 2
		if position.distance_to(Vector2(1811, 918)) < 5:
			move = false
			goingToRest = false
			rest = true
	if rest:
		# Stop all movement when at rest
		velocity = Vector2.ZERO

	if move:
		velocity = position.direction_to(mousePos) * SPEED * 2
	
	if position.distance_to(mousePos) < 10:
		move = false

	if move or goingToRest:
		animated_sprite.play("running")
	else:
		animated_sprite.play("standing")

	if velocity.x < 0:
		animated_sprite.scale.x = 2.857
	elif velocity.x > 0:
		animated_sprite.scale.x = -2.857
	else:
		animated_sprite.scale.x = 2.857

	move_and_slide()

func _process(delta):
	set_passthrough(pet_sprite)
	
	text_show_timer += delta
	
	if not text_is_visible:
		if text_show_timer >= 23.0:
			update_text()
			text.visible = true
			text_is_visible = true
			text_show_timer = 0.0 
			text_visible_timer = 0.0
	else:
		text_visible_timer += delta
		if text_visible_timer >= 7.5:
			text.visible = false
			text_show_timer = 0.0 
			text_is_visible = false

# Sets the sprite to be "clickable" and ignores mouse events outside its texture.
func set_passthrough(sprite: Sprite2D):
	var texture_center: Vector2 = sprite.texture.get_size() / 2
	var texture_corners: PackedVector2Array = [
		sprite.global_position + texture_center * Vector2(-2, -2),
		sprite.global_position + texture_center * Vector2(2, -2),
		sprite.global_position + texture_center * Vector2(2, 2),
		sprite.global_position + texture_center * Vector2(-2, 2)
	]
	DisplayServer.window_set_mouse_passthrough(texture_corners)


func update_text():
	var random_index = randi_range(0, phrases.size() - 1)
	text.text = phrases[random_index]
