extends Area2D

func _ready() -> void:
	body_entered.connect(yuzu_collected)

func yuzu_collected(other):
	print("YUZU get")
