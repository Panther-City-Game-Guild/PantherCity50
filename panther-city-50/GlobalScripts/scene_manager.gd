extends Node

# this is set by gameroot when it is ready
@onready var gameRoot: GameRoot

func GoToNewScenePacked(OldScene, NewScene: PackedScene) -> void:
	gameRoot.GoToNextScene(OldScene, NewScene)

func GoToNewSceneString(OldScene, NewScene: String) -> void:
	# TODO: add error checking
	var scene = load(NewScene)
	GoToNewScenePacked(OldScene, scene)
