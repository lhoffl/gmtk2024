extends Control

enum MAIN_MENU_STATES {MAIN_MENU, PAUSE_MENU, GAME_PLAY, GAME_WIN}
var levels = {
	"Tutorial - 1": "tutorial_level_1",
	"Tutorial - 2": "tutorial_level_2",
	"Tutorial - 3": "tutorial_level_3",
	"The Vault": "level_vault",
	"Forest": "level_forest",
	"Capybara Charge": "level_capybara_charge",
	"Cloud Taxi": "level_cloud_taxi",
	"Tall Tree": "level_tall_tree",
	}
@onready var main_menu_state = MAIN_MENU_STATES.MAIN_MENU
@onready var _world : CapyWorld = $World
@onready var _level_select_menu = $CanvasLayer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer
@onready var _canvas = $CanvasLayer
@onready var _win_screen_canvas = $CanvasLayer2
@onready var _win_screen_text = $CanvasLayer2/MarginContainer/Label
@onready var _gui_canvas = $UI_CanvasLayer
@onready var _lose_screen = $CanvasLayer3

var level_index = 0
var oasis
var yuzu

func _ready() -> void:
	addLevelsToSelect()

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		restartLevel()	
	match main_menu_state:
		MAIN_MENU_STATES.GAME_WIN:
			if Input.is_action_just_pressed("player1_jump"):
				next_level()
		MAIN_MENU_STATES.GAME_PLAY:
			_world.time_score -= delta
			_gui_canvas.update_points_label(int(_world.time_score))
			_gui_canvas.update_yuzu_label(_world.yuzu_count)
		_:
			pass

func addLevelsToSelect():
	for x in levels:
			var button = Button.new()
			button.text = x
			button.pressed.connect(_on_level_pressed.bind(x))
			_level_select_menu.add_child(button)
			
func _on_start_new_game_pressed() -> void:
	level_index = 0
	_world.time_score = levels.size() * 1000
	_world.yuzu_count = 0
	print_debug("Start New Game Pressed - Scene " + levels.get(levels.keys()[level_index]))
	load_level(levels.get(levels.keys()[level_index]))

func next_level():
	level_index += 1
	if levels.size() > level_index:
		print_debug("Triggering Next Level - Scene " + levels.get(levels.keys()[level_index]))
		load_level(levels.get(levels.keys()[level_index]))
	else:
		_win_screen_text.text = "That's all folks! Thanks for playing!"
		print_debug("No next level!")

func _on_level_pressed(x) -> void:
	level_index = levels.keys().find(x)
	_world.time_score = (levels.size() - level_index) * 1000
	_world.yuzu_count = 0
	load_level(levels[x])
	
func load_level(level_scene_name):
	print_debug("attempting to load " + level_scene_name)
	_world.show()
	_canvas.hide()
	_win_screen_canvas.hide()
	_world.load_level(level_scene_name)
	get_oasis_node_and_setup_signal()
	get_cactus_node_and_setup_signal()
	get_yuzu_node_and_setup_signal()
	change_main_menu_state(MAIN_MENU_STATES.GAME_PLAY)
	
func get_oasis_node_and_setup_signal():
	#destroy old connection
	if oasis:
		if oasis.nextLevelSignal.is_connected(_on_next_level_signal):
			oasis.nextLevelSignal.disconnect(_on_next_level_signal)
		if oasis.you_are_winner_signal.is_connected(_on_you_are_winner_signal):
			oasis.you_are_winner_signal.disconnect(_on_you_are_winner_signal)
		oasis = null
		
	#setup new connection
	oasis = searchAllNodesByName("Oasis")
	if oasis:
		oasis.nextLevelSignal.connect(_on_next_level_signal)
		oasis.you_are_winner_signal.connect(_on_you_are_winner_signal)
	else:
		print_debug("RUH ROH (main menu)")
		
func get_cactus_node_and_setup_signal():
	#setup new connection
	var spike = searchAllNodesByName("Spike")
	if spike:
		spike.youLose.connect(restartLevel)

func get_yuzu_node_and_setup_signal():
	var yuzu = searchAllNodesByName("Yuzu")
	if yuzu:
		yuzu.yuzu_get_signal.connect(_on_yuzu_get_signal)

func restartLevel():
	if main_menu_state != MAIN_MENU_STATES.GAME_WIN:
		_lose_screen.show()
		await get_tree().create_timer(0.5).timeout
	
		_lose_screen.hide()
		load_level(levels.get(levels.keys()[level_index]))

func searchAllNodesByName(node_name) -> Node:
	var nodesToCheck := get_children()
	while not nodesToCheck.is_empty():
		var node := nodesToCheck.pop_back() as Node
		nodesToCheck.append_array(node.get_children())
		if node.name == node_name:
			return node
	return null
	
func _on_yuzu_get_signal():
	_world.yuzu_count += 1
	print_debug("yuzu acquired")

func _on_next_level_signal():
	print_debug("main menu - _on_next_level_signal")
	next_level()
	
func _on_you_are_winner_signal():
	print_debug("YOU ARE WINNER (receive)")
	change_main_menu_state(MAIN_MENU_STATES.GAME_WIN)
	
func change_main_menu_state(new_state : MAIN_MENU_STATES):
	match new_state:
		MAIN_MENU_STATES.MAIN_MENU:
			main_menu_state = MAIN_MENU_STATES.MAIN_MENU
			_world.hide()
			_canvas.show()
			_win_screen_canvas.hide()
			_gui_canvas.hide()
		MAIN_MENU_STATES.PAUSE_MENU:
			main_menu_state = MAIN_MENU_STATES.PAUSE_MENU
		MAIN_MENU_STATES.GAME_PLAY:
			main_menu_state = MAIN_MENU_STATES.GAME_PLAY
			_gui_canvas.show()
		MAIN_MENU_STATES.GAME_WIN:
			main_menu_state = MAIN_MENU_STATES.GAME_WIN
			_world.players["1"].player.win_level()
			_world.players["2"].player.win_level()
			_win_screen_canvas.show()
