extends Node2D


@onready var _animated_sprite = $CharacterBody2D/AnimatedSprite2D
@onready var _character_body = $CharacterBody2D
@onready var _raycast_down = $CharacterBody2D/RayCast2D_Down
@onready var _raycast_up = $CharacterBody2D/RayCast2D_Up
@onready var _raycast_left = $CharacterBody2D/RayCast2D_Left
@onready var _raycast_right = $CharacterBody2D/RayCast2D_Right
@export var player_num = 1
@export var speed = 500.0
@export var max_speed = 20000
@export var jump_speed = 1000.0
@export var jump_frames = 10
@export var mass = 1

var buddy
var current_jump_frames = 0
var gravity_magnitude : int = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_animated_sprite.play("walk_p" + str(player_num))
	_animated_sprite.flip_h = true
	_animated_sprite.stop()
	
func _physics_process(delta):
	get_input(delta)
	apply_gravity(delta)
	_character_body.move_and_slide()
	
func apply_gravity(delta):
	_character_body.velocity.y += gravity_magnitude * delta
	
func _process(delta):
	set_facing()
	
func get_input(delta):
	if Input.is_action_pressed("player" + str(player_num) + "_left"):
		_character_body.velocity.x = lerp(_character_body.velocity.x, -1 * speed * mass, delta * .5)
	elif Input.is_action_pressed("player" + str(player_num) + "_right"):
		_character_body.velocity.x = lerp(_character_body.velocity.x, speed * mass, delta * .5)
	else:
		_character_body.velocity.x = lerp(_character_body.velocity.x, 0.0, delta * 10)
	
	if _raycast_down.is_colliding():
		if Input.is_action_just_pressed("player" + str(player_num) + "_jump"):
			print_debug("jump")
			current_jump_frames = jump_frames
			
	if current_jump_frames > 0:
		print_debug(str(current_jump_frames) + " - " + str(_character_body.velocity.y))
		current_jump_frames -= 1
		_character_body.velocity.y += lerp(_character_body.velocity.y, -1 * jump_speed, delta)
	
	if Input.is_action_just_pressed("player" + str(player_num) + "_mass") and goodToGrow():
		change_mass(0.1)
		buddy.change_mass(-0.1)
		
func goodToGrow() -> bool:
	return not (_raycast_up.is_colliding() || _raycast_left.is_colliding() || _raycast_right.is_colliding())

func set_facing():
	if Input.is_action_pressed("player" + str(player_num) + "_left"):
		_animated_sprite.play("walk_p" + str(player_num))
		_animated_sprite.flip_h = false
	elif Input.is_action_pressed("player" + str(player_num) + "_right"):
		_animated_sprite.play("walk_p" + str(player_num))
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.stop()
		
	if not _raycast_down.is_colliding():
		_animated_sprite.frame = 1
		
func change_mass(amount):
	mass = clamp((mass + amount), 0.1, 1.9)
	_character_body.scale = Vector2(mass, mass)
	
