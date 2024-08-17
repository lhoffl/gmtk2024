class_name DoorButton
extends Node2D

@export var depressed : bool = false
@export var requiredMass : float = 1

func _process(delta: float) -> void:
	if $RayCast2D.is_colliding():
		var other = $RayCast2D.get_collider().get_parent() as Player
		if other is Player and other.mass > requiredMass:
			depressed = true
			$AnimatedSprite2D.frame = 0
		else:
			depressed = false
			$AnimatedSprite2D.frame = 1
	else:
		depressed = false
		$AnimatedSprite2D.frame = 1
