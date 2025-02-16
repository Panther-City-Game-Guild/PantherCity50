extends Node

func GoToNewScenePacked(OldScene, NewScene: PackedScene) -> void:
	var rootNode = get_tree().root
	var gameRoot: GameRoot = rootNode.get_child(rootNode.get_child_count() - 1)
	gameRoot.GoToNextScene(OldScene, NewScene)

func GoToNewSceneString(OldScene, NewScene: String) -> void:
	# TODO: add error checking
	var scene = load(NewScene)
	GoToNewScenePacked(OldScene, scene)
