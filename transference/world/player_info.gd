extends Node

enum player_names {FENNEC_FOX, CAPYBARA}

@onready var _player_name_label = $PlayerInfo/VBoxContainer/PlayerNameLabel
@onready var _mass_value_label = $PlayerInfo/VBoxContainer/HBoxContainer/MassValueLabel

@export var player_name = player_names.FENNEC_FOX
@export var mass = 1.0

func _process(_delta: float) -> void:
	_player_name_label.text = getPlayerName()
	_mass_value_label.text = str(mass)
	
func getPlayerName():
	match player_name:
		player_names.FENNEC_FOX:
			return "Fennec Fox"
		player_names.CAPYBARA:
			return "Capybara"
