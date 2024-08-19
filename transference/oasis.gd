extends Node2D

<<<<<<< Updated upstream
signal nextLevelSignal

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func next_level():
	nextLevelSignal.emit()
=======
func _ready() -> void:
	$AnimatedSprite2D.play("default")
>>>>>>> Stashed changes
