extends Node2D

@export var world : Node2D

func _ready() -> void:
	$area2d.body_entered.connect(gameover)
	pass 

func _process(delta: float) -> void:
	pass

func gameover(other):
	print("DIED")
