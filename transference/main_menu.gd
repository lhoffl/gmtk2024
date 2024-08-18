extends Control

@export var levels = {}
@onready var _world : CapyWorld = $World
@onready var _level_select_menu = $CanvasLayer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer
@onready var _canvas = $CanvasLayer

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
	print_debug("start new game pressed")

func _on_level_pressed(x) -> void:
	_world.show()
	_canvas.hide()
	_world.load_level(levels[x])
	print_debug("level pressed: " + x)
