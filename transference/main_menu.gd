extends Control

var levels = {
	"Tutorial": "debug_level",
	"Tutorial - 1": "tutorial_level_1",
	"Tutorial - 2": "tutorial_level_2",
	"Capybara Charge": "level_capybara_charge"
	}
@onready var _world : CapyWorld = $World
@onready var _level_select_menu = $CanvasLayer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer
@onready var _canvas = $CanvasLayer

var level_index = 0

func _ready() -> void:
	addLevelsToSelect()

func addLevelsToSelect():
	for x in levels:
			var button = Button.new()
			button.text = x
			button.pressed.connect(_on_level_pressed.bind(x))
			_level_select_menu.add_child(button)
			
func _process(delta: float) -> void:
	pass

func _on_start_new_game_pressed() -> void:
	level_index = 0
	_world.load_level(levels.get(levels.keys()[level_index]))

func next_level():
	level_index += 1
	if levels.size() < level_index:
		_world.load_level(levels.get(levels.keys()[level_index]))

func _on_level_pressed(x) -> void:
	_world.show()
	_canvas.hide()
	_world.load_level(levels[x])
	print_debug("level pressed: " + x)
