class_name Player
extends Node2D

@onready var _animated_sprite = $CharacterBody2D/AnimatedSprite2D
@onready var _character_body = $CharacterBody2D
@onready var _raycast_rightLegDown = $CharacterBody2D/RayCast2D_Down_RightLeg
@onready var _raycast_leftLegDown = $CharacterBody2D/RayCast2D_Down_LeftLeg
@onready var _raycast_up = $CharacterBody2D/RayCast2D_Up
@onready var _raycast_left = $CharacterBody2D/RayCast2D_Left
@onready var _raycast_right = $CharacterBody2D/RayCast2D_Right
@export var player_num = 1
@export var speed = 420.0
@export var max_speed = 666
@export var mass = 1
@export var mass_modifier = 0.7
@export var coyote_frames = 10

@export var player_controlled : bool = false

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_fall : float

@onready var jump_velocity : float = ((2.0 * jump_height / jump_time_to_peak)) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height / (jump_time_to_peak * jump_time_to_peak))) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height / (jump_time_to_fall * jump_time_to_fall))) * -1

var buddy : Player
var current_jump_frames = 0
var current_coyote_frames = 0
var coyote_active : bool = true
var can_double_jump : bool = true
var swap_cooldown = 0

func _ready():
	_animated_sprite.play("idle_p" + str(player_num))
	_animated_sprite.flip_h = true
	_animated_sprite.stop()
	
	if player_num == 1:
		player_controlled = true
	
func _physics_process(delta):
	get_input(delta)
	apply_gravity(delta)
	_character_body.move_and_slide()

func get_gravity() -> float:
	var jumpMass = clampf(mass, 0.7, 1.5)
	return jump_gravity * jumpMass if _character_body.velocity.y < 0.0 else fall_gravity * jumpMass

func apply_gravity(delta):
	_character_body.velocity.y += get_gravity() * delta
	
func _process(delta):
	swap_cooldown -= 1 * delta
	set_facing()
	
func get_input(delta):
	if Input.is_action_pressed("player" + str(player_num) + "_mass") and goodToGrow():
		change_mass(mass_modifier * delta)
		buddy.change_mass(-mass_modifier * delta)
	
	var clampedSpeed = clampf(speed * 1/mass, 0, max_speed)
	if player_controlled and Input.is_action_pressed("player1_left"):
		_character_body.velocity.x = lerp(_character_body.velocity.x, -1 * clampedSpeed, delta * 0.5)
	elif player_controlled and Input.is_action_pressed("player1_right"):
		_character_body.velocity.x = lerp(_character_body.velocity.x, clampedSpeed, delta * 0.5)
	elif grounded():
		_character_body.velocity.x = lerp(_character_body.velocity.x, 0.0, delta * 10)
	
	if not player_controlled:
		_animated_sprite.play("uncontrolled_p" + str(player_num))
		return
	
	if grounded():
		current_coyote_frames = coyote_frames
		coyote_active = true
		can_double_jump = false
	else:
		coyote_active = false
		
	if coyote_active or current_coyote_frames > 0:
		current_coyote_frames -= 1
		
	if can_double_jump and Input.is_action_just_pressed("player1_jump"):
		#_character_body.velocity.y = jump_velocity
		can_double_jump = false
		
	if current_coyote_frames > 0 and Input.is_action_just_pressed("player1_jump"):
		_character_body.velocity.y = jump_velocity
		coyote_active = false
		can_double_jump = true
		current_coyote_frames = 0
		
	if Input.is_action_just_released("swapBuddies"):
		if(buddy.can_swap()):
			player_controlled = false
			swap_cooldown = 0.1
			buddy.player_controlled = true
			
func goodToGrow() -> bool:
	return not (_raycast_up.is_colliding() || _raycast_left.is_colliding() || _raycast_right.is_colliding())

func grounded() -> bool:
	return _raycast_leftLegDown.is_colliding() || _raycast_rightLegDown.is_colliding()

func set_facing():
	if not player_controlled:
		_animated_sprite.stop()
		return
	
	if Input.is_action_pressed("player1_left"):
		_animated_sprite.play("walk_p" + str(player_num))
		_animated_sprite.flip_h = false
	elif Input.is_action_pressed("player1_right"):
		_animated_sprite.play("walk_p" + str(player_num))
		_animated_sprite.flip_h = true
	else:
		_animated_sprite.play("idle_p" + str(player_num))
		
	if not grounded():
		if _character_body.velocity.y < 0:
			_animated_sprite.play("jump_p" + str(player_num))
		else:
			_animated_sprite.play("fall_p" + str(player_num))
		
func change_mass(amount):
	
	# NOTE: could be fun to change mass in air but it currently allows you to break through the floor so leave disable for now
	if !grounded() || !buddy.grounded():
		return
	mass = clamp((mass + amount), 0.25, 4)
	_character_body.scale = Vector2(mass, mass)
	
func becomePlayerControlled():
	player_controlled = true

func can_swap():
	return swap_cooldown < 0
