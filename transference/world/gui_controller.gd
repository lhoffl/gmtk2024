extends CanvasLayer

@onready var _fox_info_box = $HBoxContainer/VBoxContainer2/MarginContainer
@onready var _capybara_info_box = $HBoxContainer/VBoxContainer2/MarginContainer2
@onready var _points_value_label = $HBoxContainer/MarginContainer/NinePatchRect/PointsValue

@export var current_score = 0
@export var fox_mass = 0
@export var capybara_mass = 0

func _process(delta: float) -> void:
	_fox_info_box.mass = fox_mass
	_capybara_info_box.mass = capybara_mass
	_points_value_label.text = str(current_score)
