extends Node

### TODO:
# - Move most of the generic Game functionality to a generic Game controller node
# - HexBoard.gd should only control its child nodes and signal back to Game controller
# - GameHUD, HexBoard, and GameClock should be children of the Game controller
# - This would allow for the possibility of other game board shapes for more dynamic gameplay

### TODO:
# - Experiment with disabling _input processing for the active_board while Simon is teaching the pattern
# - This would allow for less extensive input coding and variable reliance, thus less RAM useage and processing

### TODO:
# - Consider where/when to save user data for this game

@onready var GameMenu: Panel = $GameMenu
@onready var Game: Node = $Game
var is_game_paused: bool = false
var subject_name: String = "_"
var prompt_texts: Dictionary[String, String]
var prompt_text: String
var lives: int = 3
var score: int = 0
var elapsed_time: float = 0

signal new_game
signal unpause_game
signal view_scores
signal back_to_selection
signal exit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game.connect(_new_game)
	unpause_game.connect(_unpause_game)
	back_to_selection.connect(_return_to_game_selection)
	exit.connect(_exit_app)
	
	subject_name = generate_subject_name()
	initialize_prompt_texts()


# Called when input events happen
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("pause_game"):
		# Prevent other Nodes from processing this InputEvent
		get_viewport().set_input_as_handled()
		
		# If a Game IS running and the Gamne is NOT paused, pause the game
		if Game.is_game_running && !is_game_paused:
			_pause_game()
			return
		
		# If a Game IS running and the Gamne IS paused, unpause the game
		elif Game.is_game_running && is_game_paused:
			_unpause_game()
			return
		
		# If a Game is NOT running and the GameMenu is visible, go to GameSelection
		elif !Game.is_game_running && GameMenu.visible:
			_return_to_game_selection()
			return
		
		# If a Game is NOT running and the GameMenu is NOT visible, show the GameMenu
		elif !Game.is_game_running && !GameMenu.visible:
			GameMenu.toggle_game_menu(true)
			GameMenu.toggle_resume_button(false)
			return


# Called to tell the Game controller to start a new Game
func _new_game() -> void:
	GameMenu.toggle_game_menu(false)
	GameMenu.toggle_resume_button(true)
	_unpause_game()
	Game.start_game()


# Called to Pause a Game
func _pause_game() -> void:
	if Game.is_game_running:
		is_game_paused = true
		GameMenu.toggle_game_menu(true)
		GameMenu.toggle_resume_button(true)
		get_tree().paused = true
		print("Game paused")


# Called to Unpause a Game
func _unpause_game() -> void:
	if Game.is_game_running:
		is_game_paused = false
		GameMenu.toggle_game_menu(false)
		GameMenu.toggle_resume_button(true)
		get_tree().paused = false
		print("Game unpaused")


# Called to generate a random subject name for the player
func generate_subject_name() -> String:
	var alphabet: String = "1ABC2DE3FGH4IJ5KLM6NO7PQR8ST9UVW0XYZ"
	var strg: String = ""
	for i in 4:
		strg += alphabet.substr(randi_range(0, alphabet.length() - 1), 1)
	print("str: ", strg)
	return ("_" + strg)


# Called to initialize the prompt_texts array
func initialize_prompt_texts() -> void:
	prompt_texts = {
		"welcome": "Welcome, [i]" + subject_name + "[/i].",
		"intermission": "The round begins in 3 seconds.  Get ready!",
		"teach": "[color=red]Watch closely[/color], [i]" + subject_name + "[/i].",
		"recite0": "It's your turn.  [color=green]Recite the pattern[/color].",
		"recite1": "[color=green]Recite the pattern[/color].  Good luck!",
		"victory1": "You did it, [i]" + subject_name + "[/i].  [color=blue]Well done[/color].",
		"victory2": "[color=blue]That was impressive[/color], [i]" + subject_name + "[/i], for a feline.",
		"victory3": "I can see you're not the average feline, [i]" + subject_name + "[/i]!",
		"victory4": "How are you [u]so[/u] good at this, [i]" + subject_name + "[/i]?!",
		"victory5": "Truly astonishing!  You [u]earned[/u] this, [i]" + subject_name + "[/i]: <Zoo Escape Level Password>",
		"goodbye": "You have been an [u]inspiration[/u] to felines everywhere, [i]" + subject_name + "[/i]." }
		
	prompt_text = prompt_texts["welcome"]


# Called to return to the GameSelection scene
func _return_to_game_selection() -> void:
	if find_parent("GameRoot"):
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)
	else: _exit_app()


# Called to exit the application
func _exit_app() -> void:
	get_tree().quit()


# Triggered when SimonTitle is being removed from the SceneTree
# Possibly a good time to save game options if not already done
# E.g., Triggered when returning to Game Selection
func _on_tree_exiting() -> void:
	print(name + " exiting scene tree")
