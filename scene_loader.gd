extends Node2D

@export var levels : Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var World = preload("res://transference/world/World.gd").instantiate()
	_.add_child(levels[0])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func load_level(level):
	
