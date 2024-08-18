extends StaticBody2D

enum MOVE_DIRECTIONS {LEFT, RIGHT, UP, DOWN, LEFT_UP, LEFT_DOWN, RIGHT_UP, RIGHT_DOWN}

@export var moving = false
## The direction in which the cloud moves and then returns to its original position. Diagonals are a bit wonky at the moment.
@export var move_direction = MOVE_DIRECTIONS.RIGHT
## Distance in sprite lengths.
@export var move_distance = 0.0
@export var move_speed = 10.0

@onready var _collider = $CollisionShape2D
@onready var _sprite = $CollisionShape2D/Sprite2D

var real_move_distance_x = 0
var real_move_distance_y = 0
var current_move_direction
var original_position_x
var original_position_y

func _ready():
	current_move_direction = move_direction
	original_position_x = position.x
	original_position_y = position.y
	real_move_distance_x = move_distance * _sprite.texture.get_size().x
	real_move_distance_y = move_distance * _sprite.texture.get_size().y

func _physics_process(delta):
	moveCloud(delta)
	
func moveCloud(delta):
	if moving:
		var target_x = position.x
		var target_y = position.y
		
		match current_move_direction:
			MOVE_DIRECTIONS.LEFT:
				target_x = original_position_x + (-1 * real_move_distance_x)
			MOVE_DIRECTIONS.RIGHT:
				target_x = original_position_x + real_move_distance_x
			MOVE_DIRECTIONS.UP:
				target_y = original_position_y + (-1 * real_move_distance_y)
			MOVE_DIRECTIONS.DOWN:
				target_y = original_position_y + (real_move_distance_y)
			MOVE_DIRECTIONS.LEFT_UP:
				target_x = original_position_x + (-1 * real_move_distance_x)
				target_y = original_position_y + (-1 * real_move_distance_y)
			MOVE_DIRECTIONS.LEFT_DOWN:
				target_x = original_position_x + (-1 * real_move_distance_x)
				target_y = original_position_y + (real_move_distance_y)
			MOVE_DIRECTIONS.RIGHT_UP:
				target_x = original_position_x + real_move_distance_x
				target_y = original_position_y + (-1 * real_move_distance_y)
			MOVE_DIRECTIONS.RIGHT_DOWN:
				target_x = original_position_x + real_move_distance_x
				target_y = original_position_y + (real_move_distance_y)
			-1:
				target_x = original_position_x
				target_y = original_position_y
				
		if abs(target_x - position.x) < 0.1 and abs(target_y - position.y) < 0.1:
			if current_move_direction == move_direction:
				current_move_direction = -1
			else:
				current_move_direction = move_direction
				
		changeCloudPosition(target_x, target_y, delta)
				
func changeCloudPosition(x, y, delta):
	position.x = move_toward(position.x, x, delta * move_speed)
	position.y = move_toward(position.y, y, delta * move_speed)
