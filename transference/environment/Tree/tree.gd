extends Node2D

@onready var _raycasts = $Fronds_StaticBody/Raycasts
@onready var _leftRays = $Fronds_StaticBody/Raycasts/LeftRays
@onready var _rightRays = $Fronds_StaticBody/Raycasts/RightRays

@onready var _trunk = $Trunk
@onready var _frond = $Fronds_StaticBody
@onready var _frond_sprite = $Fronds_StaticBody/Sprite2D
@export var _tree_height = 4
@export var _tree_stand_delay = 300.0

@export var _rightBendAmount = 90
@export var _leftBendAmount = -90
@export var _requiredMass = 1.5
@export var _neutralBendAmount = 0

enum treeStates {STAND, BEND, BEND_UP, BEND_DOWN, BENT}
var treeState
@export var rotation_speed = 1.5
@export var return_speed = 10
var trunk_segments = []
var top_trunk
var raycasts = []
var rightRays = []
var leftRays = []

var bendDegree = 0

var is_bending = false
var is_bending_right = false
var player
var current_stand_delay
@onready var targetFrondRotationDegrees = 0.0

func _ready():
	
	for x in _raycasts.get_children():
		raycasts.append(x)
		
	for x in _leftRays.get_children():
		leftRays.append(x)
		
	for x in _rightRays.get_children():
		rightRays.append(x)
	
	buildTree()
	treeState = treeStates.STAND
	current_stand_delay = _tree_stand_delay
	_frond_sprite.rotation = 0.0
	
func buildTree():
	for n in _tree_height:
		var new_segment = preload("res://transference/environment/Tree/trunk_segment.tscn").instantiate()
		_trunk.add_child(new_segment)
		new_segment.position.y = -8 * n
		trunk_segments.append(new_segment)
	top_trunk = trunk_segments[trunk_segments.size() - 1]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):	
	var leftCount = 0
	var rightCount = 0
	
	for leftRay in leftRays:
		if leftRay.is_colliding():
			leftCount += 1
			player = leftRay.get_collider().get_parent()
	for rightRay in rightRays:
		if rightRay.is_colliding():
			rightCount += 1
			player = rightRay.get_collider().get_parent()
	
	if treeState not in [treeStates.BEND, treeStates.BENT] and (leftCount > 0 or rightCount > 0) and player and player.mass > _requiredMass:			
		treeState = treeStates.BEND
		if(rightCount > leftCount):
			is_bending_right = true
		elif(leftCount > rightCount):
			is_bending_right = false
	elif treeState == treeStates.BENT and not ((leftCount > 0 or rightCount > 0) and player and player.mass > _requiredMass):
		current_stand_delay -= 1
		if current_stand_delay <= 0:
			current_stand_delay = _tree_stand_delay
			treeState = treeStates.STAND
			
	match treeState:
		treeStates.STAND:
			bendToState(treeStates.STAND, delta, _neutralBendAmount)
		treeStates.BEND:
			if is_bending_right:
				bendToState(treeStates.BEND, delta, _rightBendAmount)
			else:
				bendToState(treeStates.BEND, delta, _leftBendAmount)
				
	positionFrond()
	shakeFrond(delta)

func positionFrond():
	_frond.global_position.x = top_trunk.global_position.x
	_frond.global_position.y = top_trunk.global_position.y - 4
	
func shakeFrond(delta):
	var rotateLeft = -15.0
	var rotateRight = 15.0
	if current_stand_delay / _tree_stand_delay < .5:
		if targetFrondRotationDegrees == 0.0:
			targetFrondRotationDegrees = rotateLeft
			
		if abs(_frond_sprite.rotation - deg_to_rad(rotateLeft)) < 0.1:
			targetFrondRotationDegrees = rotateRight
		elif abs(_frond_sprite.rotation - deg_to_rad(rotateRight)) < 0.1:
			targetFrondRotationDegrees = rotateLeft
	else:
		targetFrondRotationDegrees = 0.0
		
	_frond_sprite.rotation = move_toward(_frond_sprite.rotation, deg_to_rad(targetFrondRotationDegrees), delta)
	pass

func bendToState(newState, delta, bendDegree):
	if newState	 == treeStates.BEND:
		if abs(_trunk.rotation - deg_to_rad(bendDegree)) < 0.1:
			treeState = treeStates.BENT
		_trunk.rotation = lerp(_trunk.rotation, deg_to_rad(bendDegree), delta * rotation_speed)
	if newState	 == treeStates.STAND:
		if _trunk.rotation == deg_to_rad(_neutralBendAmount):
			treeState = treeStates.STAND
		_trunk.rotation = lerp(_trunk.rotation, deg_to_rad(0), delta * return_speed)
