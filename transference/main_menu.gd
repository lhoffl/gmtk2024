extends Control

@export var levels = {}

@onready var _level_select_menu = $CanvasLayer/MarginContainer/VBoxContainer/ScrollContainer/HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addLevelsToSelect()

func addLevelsToSelect():
	for x in levels:
			var button = Button.new()
			button.text = x
			button.pressed.connect(_on_level_pressed.bind(x))
			_level_select_menu.add_child(button)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_new_game_pressed() -> void:
	print_debug("start new game pressed")
	pass # Replace with function body.

func _on_level_pressed(x) -> void:
	print_debug("level pressed: " + x)
