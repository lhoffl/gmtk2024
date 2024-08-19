extends Node2D

signal nextLevelSignal

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func next_level():
	nextLevelSignal.emit()
