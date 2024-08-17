class_name DoorButton
extends Node2D

@export var depressed : bool = false

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		depressed = true
		$AnimatedSprite2D.frame = 0
		
	else:
		depressed = false
		$AnimatedSprite2D.frame = 1
