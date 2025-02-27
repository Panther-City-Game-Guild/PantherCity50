extends Node

@onready var hBoard := preload("res://Simon/Scenes/HexBoard.tscn")
@onready var SimonMenu := $SimonMenu
@onready var SimonHUD := $SimonHUD
@onready var HexBoard := $HexBoard

var game_on: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PauseNode.game_unpaused.connect(_resume_game)
	SimonMenu.connect("resume_game", _resume_game)
	SimonMenu.connect("new_game", _new_game)
	SimonMenu.connect("back_to_selection", _return_to_game_selection)
	SimonMenu.connect("exit", _exit_app)


# Called when input events happen
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		# TODO Include the "pause_game" as a way to pause and unpause Simon
	#if Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("pause_game"):
		get_viewport().set_input_as_handled()
		if game_on: SimonMenu.set_visibility(true, true)
		else: SimonMenu.set_visibility(true, false)
		
		if game_on && !get_tree().paused:
			print("pausing game")
			get_tree().paused = true


func _resume_game() -> void:
	if game_on:
		_unpause_game()


func _new_game() -> void:
	game_on = true
	SimonMenu.set_visibility(false, true)
	_unpause_game()
	HexBoard.start_game()


# Return Button UP -- Returrn to Game Selection screen
func _return_to_game_selection() -> void:
	if get_parent().name == "GameRoot":
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)


func _unpause_game() -> void:
	SimonMenu.set_visibility(false, true)
	get_tree().paused = false


func _exit_app() -> void:
	get_tree().quit()


# Triggered when SimonTitle is being removed from the SceneTree
# E.g., Triggered when returning to Game Selection
func _on_tree_exiting() -> void:
	print("SimonTitle exiting scene tree")
