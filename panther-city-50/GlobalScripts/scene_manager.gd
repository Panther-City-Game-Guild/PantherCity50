extends Node

# this is set by gameroot when it is ready
@onready var gameRoot: GameRoot

func GoToNewScenePacked(OldScene: Node, NewScene: PackedScene) -> void:
	gameRoot.GoToNextScene(OldScene, NewScene)

func GoToNewSceneString(OldScene: Node, NewScene: String) -> void:
	# TODO: add error checking
	var scene: Resource = load(NewScene)
	GoToNewScenePacked(OldScene, scene)
