class_name CapyWorld
extends Node2D

@export var level_num = 0
@onready var viewport = $VBoxContainer/SubViewportContainer/SubViewport
var level_instance

func load_level(level_name):
	if viewport.get_child_count() > 1:
		viewport.remove_child(viewport.get_child(1))
	
	var level_path := "res://transference/Levels/%s.tscn" % level_name
	var level_resource := load(level_path)
	if level_resource:
		level_instance = level_resource.instantiate()
		level_instance.name = "CurrentLevel"
		viewport.add_child(level_instance)
		
		var players := {
			"1": {
				viewport = $VBoxContainer/SubViewportContainer/SubViewport,
				camera = $VBoxContainer/SubViewportContainer/SubViewport/Camera2D,
				player = $VBoxContainer/SubViewportContainer/SubViewport/CurrentLevel/Player_1
			},
			"2": {
				viewport = $VBoxContainer/SubViewportContainer2/SubViewport2,
				camera = $VBoxContainer/SubViewportContainer2/SubViewport2/Camera2D,
				player = $VBoxContainer/SubViewportContainer/SubViewport/CurrentLevel/Player_2
			}
		}
		players["2"].viewport.world_2d = players["1"].viewport.world_2d
		players["1"].player.buddy = players["2"].player
		players["2"].player.buddy = players["1"].player
		for node in players.values():
			var remote_transform := RemoteTransform2D.new()
			remote_transform.remote_path = node.camera.get_path()
			node.player.get_node_or_null("CharacterBody2D").add_child(remote_transform)
	else:
		print("RUH ROH")
		
