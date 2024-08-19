extends Control

var levels = {
	"Tutorial - 1": "tutorial_level_1",
	"Tutorial - 2": "tutorial_level_2",
	"Tutorial - 3": "tutorial_level_3",
	"Capybara Charge": "level_capybara_charge"
	}
@onready var _world : CapyWorld = $World
@onready var _level_select_menu = $CanvasLayer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer
@onready var _canvas = $CanvasLayer

var level_index = 0
var oasis

func _ready() -> void:
	addLevelsToSelect()

func addLevelsToSelect():
	for x in levels:
			var button = Button.new()
			button.text = x
			button.pressed.connect(_on_level_pressed.bind(x))
			_level_select_menu.add_child(button)
			
func _on_start_new_game_pressed() -> void:
	level_index = 0
	print_debug("Start New Game Pressed - Scene " + levels.get(levels.keys()[level_index]))
	load_level(levels.get(levels.keys()[level_index]))

func next_level():
	level_index += 1
	if levels.size() > level_index:
		print_debug("Triggering Next Level - Scene " + levels.get(levels.keys()[level_index]))
		load_level(levels.get(levels.keys()[level_index]))
	else:
		print_debug("No next level!")

func _on_level_pressed(x) -> void:
	level_index = levels.keys().find(x)
	load_level(level_index)
	
func load_level(level_scene_name):
	print_debug("attempting to load " + level_scene_name)
	_world.show()
	_canvas.hide()
	_world.load_level(level_scene_name)
	get_oasis_node_and_setup_signal()
	
func get_oasis_node_and_setup_signal():
	#destroy old connection
	if oasis and oasis.nextLevelSignal.is_connected(_on_next_level_signal):
		oasis.nextLevelSignal.disconnect(_on_next_level_signal)
		oasis = null
		
	#setup new connection
	oasis = searchAllNodesByName("Oasis")
	if oasis:
		oasis.nextLevelSignal.connect(_on_next_level_signal)
	else:
		print_debug("RUH ROH (main menu)")
	
func searchAllNodesByName(node_name) -> Node:
	var nodesToCheck := get_children()
	while not nodesToCheck.is_empty():
		var node := nodesToCheck.pop_back() as Node
		nodesToCheck.append_array(node.get_children())
		if node.name == node_name:
			return node
	return null

func _on_next_level_signal():
	print_debug("main menu - _on_next_level_signal")
	next_level()
