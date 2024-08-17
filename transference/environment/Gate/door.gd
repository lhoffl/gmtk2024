class_name Door
extends Node2D

@export var open : bool = false

@export var button : DoorButton

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if button.depressed :
		$AnimatedSprite2D.frame = 1
		open = true
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
		
	else:
		$AnimatedSprite2D.frame = 0
		open = false
		$StaticBody2D/CollisionShape2D.set_deferred("disabled", false)
