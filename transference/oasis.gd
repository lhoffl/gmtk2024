extends Node2D

signal nextLevelSignal
signal you_are_winner_signal

@onready var _oasis_area = $Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _physics_process(_delta):
	check_win_condition()

func check_win_condition():
	if _oasis_area.has_overlapping_bodies():
		var num_players = 0
		for x in _oasis_area.get_overlapping_bodies():
			if x.get_parent().name.match("*Player*"):
				num_players += 1
		if num_players >= 2:
			print_debug("YOU ARE WINNER (emit)")
			you_are_winner_signal.emit()		
		
func next_level():
	nextLevelSignal.emit()
