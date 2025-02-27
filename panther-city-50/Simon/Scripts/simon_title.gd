extends Node

@onready var hBoard := preload("res://Simon/Scenes/HexBoard.tscn")
@onready var SimonMenu := $SimonMenu
@onready var SimonHUD := $SimonHUD
@onready var HexBoard := $HexBoard

var game_on: bool = false
var is_game_paused: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SimonMenu.connect("resume_game", _unpause_game)
	SimonMenu.connect("new_game", _new_game)
	SimonMenu.connect("back_to_selection", _return_to_game_selection)
	SimonMenu.connect("exit", _exit_app)


# Called when input events happen
func _input(_event: InputEvent) -> void:
	# TODO Include "pause_game" as a way to pause and unpause Simon	
	if Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("pause_game"):
		get_viewport().set_input_as_handled()
		if game_on && !is_game_paused:
			_pause_game()
			
		elif game_on && is_game_paused:
			_unpause_game()


func _new_game() -> void:
	game_on = true
	SimonMenu.set_visibility(false, true)
	_unpause_game()
	HexBoard.start_game()


func _return_to_game_selection() -> void:
	if get_parent().name == "GameRoot":
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)


func _pause_game() -> void:
	if game_on:
		is_game_paused = true
		SimonMenu.set_visibility(true, true)
		get_tree().paused = true
		print("Simon paused")


func _unpause_game() -> void:
	if game_on:
		is_game_paused = false
		SimonMenu.set_visibility(false, true)
		get_tree().paused = false
		print("Simon unpaused")


func _exit_app() -> void:
	get_tree().quit()


# Triggered when SimonTitle is being removed from the SceneTree
# E.g., Triggered when returning to Game Selection
func _on_tree_exiting() -> void:
	print("SimonTitle exiting scene tree")
