extends Node2D

signal nextLevelSignal

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _process(delta):
	# TODO: remove debug action for next level
	if Input.is_action_just_pressed("player1_crouch"):
		next_level()

func next_level():
	print_debug("emitting nextLevelSignal")
	nextLevelSignal.emit()
