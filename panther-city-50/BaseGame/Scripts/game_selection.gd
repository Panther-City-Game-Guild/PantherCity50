extends Node2D

var gameIcons: Array[Button]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for gameIcon in $FlowContainer.get_children():
		if gameIcon.name.begins_with("GameIcon"):
			gameIcons.append(gameIcon)
					
	if gameIcons:
		gameIcons[0].grab_focus()


func _on_game_icon_start_game(gameToStart: PackedScene) -> void:
	SceneManager.GoToNewScenePacked(self, gameToStart)
