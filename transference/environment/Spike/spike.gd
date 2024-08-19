extends Node2D

@export var world : Node2D
signal youLose

func _ready() -> void:
	$area2d.body_entered.connect(gameover)

func gameover(other):
	print("DIED")
	youLose.emit()
