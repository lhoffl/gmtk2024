extends Node2D

@onready var _raycasts = $Fronds_StaticBody/Raycasts
@onready var _trunk = $Trunk
@onready var _frond = $Fronds_StaticBody
@export var _tree_height = 4

enum treeStates {STAND, BEND, BEND_UP, BEND_DOWN}
var treeState
@export var rotation_speed = 1.5
var trunk_segments = []
var top_trunk
var raycasts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for x in _raycasts.get_children():
		raycasts.append(x)
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
	if raycasts.any(func(r): return r.is_colliding()):
		bendToState(treeStates.BEND, delta)
	else:
		bendToState(treeStates.STAND, delta)
	positionFrond()

func positionFrond():
	_frond.global_position.x = top_trunk.global_position.x
	_frond.global_position.y = top_trunk.global_position.y - 4

func bendToState(newState, delta):
	if not treeState == newState:
		if newState	 == treeStates.BEND:
			if _trunk.rotation == deg_to_rad(90):
				treeState = treeStates.BEND
			else:
				treeState = treeStates.BEND_DOWN
			_trunk.rotation = lerp(_trunk.rotation, deg_to_rad(90), delta * rotation_speed)
		if newState	 == treeStates.STAND:
			if _trunk.rotation == deg_to_rad(90):
				treeState = treeStates.STAND
			else:
				treeState = treeStates.BEND_UP
			_trunk.rotation = lerp(_trunk.rotation, deg_to_rad(0), delta * rotation_speed)
