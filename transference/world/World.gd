extends Node2D

@onready var players := {
	"1": {
		viewport = $VBoxContainer/SubViewportContainer/SubViewport,
		camera = $VBoxContainer/SubViewportContainer/SubViewport/Camera2D,
		player = $VBoxContainer/SubViewportContainer/SubViewport/DebugLevel/Player_1
	},
	"2": {
		viewport = $VBoxContainer/SubViewportContainer2/SubViewport2,
		camera = $VBoxContainer/SubViewportContainer2/SubViewport2/Camera2D,
		player = $VBoxContainer/SubViewportContainer/SubViewport/DebugLevel/Player_2
	}
}

# Called when the node enters the scene tree for the first time.
func _ready():
	players["2"].viewport.world_2d = players["1"].viewport.world_2d
	players["1"].player.buddy = players["2"].player
	players["2"].player.buddy = players["1"].player
	for node in players.values():
		var remote_transform := RemoteTransform2D.new()
		remote_transform.remote_path = node.camera.get_path()
		node.player.get_node_or_null("CharacterBody2D").add_child(remote_transform)
