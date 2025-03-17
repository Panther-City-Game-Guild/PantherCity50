extends Node

### TODO:
# - Move most of the generic Game functionality to this script or a generic Game controller node
# - HexBoard.gd should only control its child nodes and signal back to this node or generic Game controller
# - SimonHUD, HexBoard, and GameClock should be children of this or the Game controller
# - This would allow for the possibility of other game board shapes for "easy, normal, and hard" modes
# - E.g., Easy = Triangle with 3 Areas; Normal = Circle with 4 Areas; Hard = Hexagon with 6 Areas

@onready var SimonMenu := $SimonMenu
@onready var SimonHUD := $SimonHUD
@onready var HexBoard := $HexBoard
@onready var GameClock := $GameClock
var game_on: bool = false
var is_game_paused: bool = false
var subject_name: String = "_"
var prompt_texts: Dictionary[String, String]
var prompt_text: String
var lives: int = 3
var score: int = 0
var elapsed_time: float = 0

signal new_game
signal unpause_game
signal back_to_selection
signal exit
signal start_game_clock(secs: float)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game.connect(_new_game)
	unpause_game.connect(_unpause_game)
	back_to_selection.connect(_return_to_game_selection)
	exit.connect(_exit_app)
	
	subject_name = generate_subject_name()
	initialize_prompt_texts()
	
	# Clock-related setup
	start_game_clock.connect(func(secs: float) -> void: GameClock.start(secs))
	GameClock.one_shot = true
	GameClock.autostart = false


# Called when input events happen
func _input(event: InputEvent) -> void:
	# TODO Include "pause_game" as a way to pause and unpause Simon	
	if event.is_action_pressed("ui_cancel") || event.is_action_pressed("pause_game"):
		get_viewport().set_input_as_handled()
		if game_on && !is_game_paused:
			_pause_game()
			
		elif game_on && is_game_paused:
			_unpause_game()


func _new_game() -> void:
	game_on = true
	SimonMenu.set_visibility(false, true)
	_unpause_game()
	SimonHUD.update_prompt()
	HexBoard.start_game()
	# TODO: Refactor this script so recital_timee is the countdown timer
	GameClock.start(300)


func _return_to_game_selection() -> void:
	if find_parent("GameRoot"):
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)
	else: _exit_app()


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


func generate_subject_name() -> String:
	var alphabet: String = "1ABC2DE3FGH4IJ5KLM6NO7PQR8ST9UVW0XYZ"
	var strg: String = ""
	for i in 4:
		strg += alphabet.substr(randi_range(0, alphabet.length() - 1), 1)
	print("str: ", strg)
	return ("_" + strg)

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


func _exit_app() -> void:
	get_tree().quit()


# Triggered when SimonTitle is being removed from the SceneTree
# E.g., Triggered when returning to Game Selection
func _on_tree_exiting() -> void:
	print("SimonTitle exiting scene tree")
