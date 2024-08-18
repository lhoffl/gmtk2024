extends Node2D

@onready var _raycasts = $Fronds_StaticBody/Raycasts
@onready var _leftRays = $Fronds_StaticBody/Raycasts/LeftRays
@onready var _rightRays = $Fronds_StaticBody/Raycasts/RightRays

@onready var _trunk = $Trunk
@onready var _frond = $Fronds_StaticBody
@export var _tree_height = 4

@export var _rightBendAmount = 90
@export var _leftBendAmount = -90
@export var _requiredMass = 1.5
@export var _neutralBendAmount = 45

enum treeStates {STAND, BEND, BEND_UP, BEND_DOWN}
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

func _ready():
	
	for x in _raycasts.get_children():
		raycasts.append(x)
		
	for x in _leftRays.get_children():
		leftRays.append(x)
		
	for x in _rightRays.get_children():
		rightRays.append(x)
	
	buildTree()
	treeState = treeStates.STAND
	
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
	
	if (leftCount > 0 or rightCount > 0) and player and player.mass > _requiredMass:			
		if not is_bending:
			is_bending = true
			if(rightCount > leftCount):
				is_bending_right = true
				bendToState(treeStates.BEND, delta, _rightBendAmount)
			elif(leftCount > rightCount):
				is_bending_right = false
				bendToState(treeStates.BEND, delta, _leftBendAmount)
		else:
			if is_bending_right:
				bendToState(treeStates.BEND, delta, _rightBendAmount)
			else:
				bendToState(treeStates.BEND, delta, _leftBendAmount)
	else:
		is_bending = false
		bendToState(treeStates.STAND, delta, _neutralBendAmount)
		
	positionFrond()

func positionFrond():
	_frond.global_position.x = top_trunk.global_position.x
	_frond.global_position.y = top_trunk.global_position.y - 4

func bendToState(newState, delta, bendDegree):
	if not treeState == newState:
		if newState	 == treeStates.BEND:
			if _trunk.rotation == deg_to_rad(bendDegree):
				treeState = treeStates.BEND
			else:
				treeState = treeStates.BEND_DOWN
			_trunk.rotation = lerp(_trunk.rotation, deg_to_rad(bendDegree), delta * rotation_speed)
		if newState	 == treeStates.STAND:
			if _trunk.rotation == deg_to_rad(_neutralBendAmount):
				treeState = treeStates.STAND
			else:
				treeState = treeStates.BEND_UP
			_trunk.rotation = lerp(_trunk.rotation, deg_to_rad(0), delta * return_speed)
