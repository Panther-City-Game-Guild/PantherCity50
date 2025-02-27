extends Node


# This is set by gameroot when it is ready
@onready var gameRoot: GameRoot


func _ready() -> void:
	# Set the root node so it (and its children set to Inherit mode) cannot be paused
	# Inherit mode is default for Nodes, so set your game node's mode to Pausable
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS


func GoToNewScenePacked(OldScene: Node, NewScene: PackedScene) -> void:
	# Before switching to another scene, make sure the scene tree is not paused
	# This happens if a game is exited while paused
	get_tree().paused = false
	
	# Switch the scenes
	gameRoot.GoToNextScene(OldScene, NewScene)


func GoToNewSceneString(OldScene: Node, NewScene: String) -> void:
	# TODO: add error checking
	var scene: Resource = load(NewScene)
	GoToNewScenePacked(OldScene, scene)
