extends CanvasLayer

@onready var _fox_info_box = $HBoxContainer/VBoxContainer2/MarginContainer
@onready var _capybara_info_box = $HBoxContainer/VBoxContainer2/MarginContainer2
@onready var _points_value_label = $HBoxContainer/MarginContainer/NinePatchRect/PointsValue
@onready var _yuzu_value_label = $HBoxContainer/MarginContainer/NinePatchRect/YuzuValue

@export var fox_mass = 0
@export var capybara_mass = 0

func _process(delta: float) -> void:
	_fox_info_box.mass = fox_mass
	_capybara_info_box.mass = capybara_mass


func update_points_label(points):
	_points_value_label.text = str(points)
	
func update_yuzu_label(yuzus):
	_yuzu_value_label.text = str(yuzus)
