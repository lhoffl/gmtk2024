extends Node3D


func _ready():
	$"../Monkey".global_position = global_position

func _process(delta):
	
	if(Input.is_action_just_pressed("respawn")):
		$"../Monkey".global_position = global_position
