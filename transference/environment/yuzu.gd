extends Area2D

signal yuzu_get_signal

func _ready() -> void:
	body_entered.connect(yuzu_collected)

func yuzu_collected(_x):
	print("YUZU get")
	yuzu_get_signal.emit()
	queue_free()
