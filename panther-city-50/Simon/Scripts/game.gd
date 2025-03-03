extends Node

### Exported Variables
# Color Settings
@export_category("Color Settings")
@export var colors: Array[String] = [ # Array of color codes for the clickable Areas
	# Red, Blue, Yellow, Green used in 4-Color Simon
	# Red, Yellow, Green, Purple, Blue, Orange using 6-Color Simon
	"#FF0000",	# 0 Red		#660000 DIM
	"#FFFF00",	# 1 Yellow	#666600 DIM
	"#00FF00",	# 2 Green	#006600 DIM
	"#CC00CC",	# 3 Purple	#520052 DIM
	"#3366FF",	# 4 Blue	#142966 DIM
	"#FF9900" ]	# 5 Orange	#663D00 DIM
@export var dark_pct: float = 0.6 # Percent to darken the color
# Timer Durations
@export_category("Pattern Settings")
@export var teach_time: float = 0.3 # Number of seconds between lighting different Areas during teaching
@export var display_time: float = 0.3 # Number of seconds to keep an area lit during teaching
@export var recital_time: float = 5 # Number of seconds user has to recite the pattern (before being penalized)
@export var intermission_time: float = 2 # Number of seconds before round begins
@export var pattern_length: int = 1 # Number of colors in the rand_pattern; default 1
@export_category("Board Settings")
@export var current_board: Dictionary = { "Hexagon": 6, "Circle": 4, "Square": 4, "Diamond": 4 }

### Non-Exported Variables
# Game Child Nodes
@onready var GameHUD := $GameHUD
@onready var HexBoard := $HexBoard
# Other Variables
var rng: RandomNumberGenerator = RandomNumberGenerator.new() # Generic RandomNumberGenerator
var rand_pattern: Array[int] = [] # Store the randomly generated color pattern
var input_pattern: Array[int] = [] # Store the user's recited pattern
var input_length: int = 0 # Length of the user's input pattern
var next_input: int = 0 # Which input index is expected next
var lives: int = 3 # The player's lives, default 3
var score: int = 0 # The player's score
var round_score: int = 0 # The player's score from this round
var is_game_running: bool = false # Is a game in progress?
var waiting_for_input: bool = false # Are we waiting for user input?
var has_pattern_played: bool = false # Has the user seen the pattern this round?
var are_areas_locked: bool = false # Are the clickable Areas locked?
var in_intermission: bool = false # Are we between rounds?
var elapsed_time: float = 0.00 # How long the user has taken to give input
var play_demo: bool = false # Should the Demo play?
var area_triggered: int = -1 # Which area is triggered; 0-5, -1 for none


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameHUD.visible = false
	HexBoard.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	# If a game is running
	if is_game_running:
		pass
