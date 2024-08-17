class_name Door
extends Node2D

@export var open : bool = false
@export var buttons : Array[DoorButton] = []

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	var oneButtonDepressed = false
	for button in buttons:
		if button.depressed :
			oneButtonDepressed = true

	if oneButtonDepressed :
		$AnimatedSprite2D.frame = 1
		open = true
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
		
	else:
		$AnimatedSprite2D.frame = 0
		open = false
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
