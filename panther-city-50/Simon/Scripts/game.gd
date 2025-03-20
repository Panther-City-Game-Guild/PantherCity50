extends Node

### Exported Variables
# Color Settings
@export_category("Color Settings")
@export var area_colors: Array[String] = [ # Array of color codes for the clickable Areas
	# Red, Blue, Yellow, Green used in 4-Color Simon
	# Red, Yellow, Green, Purple, Blue, Orange using 6-Color Simon
	"#FF0000",	# 1 Red		#660000 DIM
	"#FFFF00",	# 2 Yellow	#666600 DIM
	"#00FF00",	# 3 Green	#006600 DIM
	"#CC00CC",	# 4 Purple	#520052 DIM
	"#3366FF",	# 5 Blue	#142966 DIM
	"#FF9900" ]	# 6 Orange	#663D00 DIM
@export var dark_pct: float = 0.3 # Percent to darken the color
# Timer Durations
@export_category("Pattern Settings")
@export var teach_time: float = 0.3 # Number of seconds between lighting different Areas during teaching
@export var display_time: float = 0.3 # Number of seconds to keep an area lit during teaching
@export var recital_time: float = 7 # Number of seconds user has to recite the pattern (before being penalized)
@export var intermission_time: float = 2 # Number of seconds before round begins
@export var pattern_length: int = 1 # Number of colors in the rand_pattern; default 1
@export_category("Board Settings")
@export_enum("Hexagon", "Circle", "Diamond", "Triangle") var selected_board: int = 0

### Non-Exported Variables
# Game Child Nodes
@onready var GameBoards: Array[Node2D] = [$HexBoard, $HexBoard, $HexBoard, $HexBoard]
@onready var GameHUD: Control = $GameHUD
@onready var GameClock: Timer = $GameClock
@onready var active_board: Node2D = GameBoards[0] # Which board is currently being used
# Other Variables
var max_areas: int = 4 # How many areas does the active_board have
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
	for Board in GameBoards:
		Board.visible = false


### Begin InputEvent Checks
func _input(event: InputEvent) -> void:
	# If a game is in progress and the areas are not locked
	if is_game_running && !are_areas_locked:
		var i: int = 0
		# If an Action was just pressed
		# <1> pressed
		if event.is_action_pressed("trigger_ability_1"): i = 1
		# <2> pressed
		if event.is_action_pressed("trigger_ability_2"): i = 2
		# <3> pressed
		if event.is_action_pressed("trigger_ability_3"): i = 3
		# <4> pressed
		if event.is_action_pressed("trigger_ability_4"): i = 4
		# <5> pressed
		if event.is_action_pressed("trigger_ability_5"): i = 5
		# <6> pressed
		if event.is_action_pressed("trigger_ability_6"): i = 6
		# If one of the above was true, trigger that area
		if i >= 1 && i <= max_areas:
			if verify_input(i): active_board.trigger_area(i - 1)
### End InputEvent Checks



### Begin Game Loop
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Are we waiting for user input?
	if waiting_for_input && !in_intermission:
		# If so, increase the elapsed_time
		elapsed_time += delta
	
	# If a game is in progress . . .
	if is_game_running && !in_intermission:
		
		# If the user has not seen the pattern this round, show them
		if !has_pattern_played:
			has_pattern_played = true
			
			# After the intermission time, teach the pattern to the user
			# TODO: Add a Round Start countdown timer to the UI
			print(" Round begins in ", intermission_time, " seconds!")
			print("Pattern length: ", pattern_length, " | Recital time: ", recital_time)
			print("   Pattern: ", rand_pattern)
			
			# Lock the clickable color areas
			await get_tree().create_timer(intermission_time / 2).timeout
			toggle_area_locks()
			
			# Teach the pattern
			await get_tree().create_timer(intermission_time / 2).timeout
			for i: int in rand_pattern:
				# Light up the Area
				active_board.light_area(i - 1)
				
				# Wait and then dim the Area
				await get_tree().create_timer(display_time, false, false, false).timeout
				active_board.dim_area(i - 1)
				
				# Go to next Area
				await get_tree().create_timer(teach_time, false, false, false).timeout
			
			# Unlock the clickable color areas and wait for user input
			await get_tree().create_timer(intermission_time / 2).timeout
			toggle_area_locks()
			waiting_for_input = true
		
		# If the user clicked enough correct colors
		if input_length == pattern_length:
			waiting_for_input = false
			print("  Round completed in ", floor(elapsed_time), " / ", recital_time, " seconds!")
			pause_loop()
			calc_bonus_score()
			calc_bonus_lives()
			
			# TODO: Make a screen with recap and button for leveling up!
			level_up()
### End Game Loop


# Set the active board based on settings (HexBoard by default)
func set_active_board() -> void:
	# TODO: Alter these as new boards get implemented
	if selected_board == 0:
		active_board = GameBoards[selected_board] # Hexagon
		max_areas = 6
	if selected_board == 1:
		active_board = GameBoards[selected_board] # Circle
		max_areas = 4
	if selected_board == 2:
		active_board = GameBoards[selected_board] # Diamond
		max_areas = 4
	if selected_board == 3:
		active_board = GameBoards[selected_board] # Triangle
		max_areas = 3


# Begin a new game
func start_game() -> void:
	# Disable the demo
	play_demo = false
	
	# Reset all game parameters
	if reset_game():
		# Generate a rand_pattern to teach the player
		make_pattern(pattern_length) # Depends on rng and pattern_length
		
		# Calculate time user has to recite pattern
		calc_recital_time() # Depends on teach_time, display_time, and pattern_length
		
		GameHUD.visible = true
		active_board.visible = true
		# Start the game
		print("Starting a new game")
		is_game_running = true


# Called to reset all game variables
func reset_game() -> bool:
	is_game_running = false
	waiting_for_input = false
	has_pattern_played = false
	are_areas_locked = false
	in_intermission = false
	pattern_length = 3
	input_length = 0
	next_input = 0
	elapsed_time = 0
	lives = 3
	score = 0
	round_score = 0
	rand_pattern.clear()
	input_pattern.clear()
	return true


# Called to reset variables for the game's next level/round
func level_up() -> void:
	# Reset many of the game's variables for the next level
	waiting_for_input = false
	has_pattern_played = false
	are_areas_locked = false
	in_intermission = false
	input_length = 0
	next_input = 0
	elapsed_time = 0
	round_score = 0
	input_pattern.clear()
	
	# Increase the pattern by 1 color & update the recital time
	increase_pattern_length()
	calc_recital_time()


# Called when showing scores between rounds
func pause_loop() -> void:
	in_intermission = !in_intermission


# Generate a rand_pattern to teach the player
func make_pattern(length: int) -> void:
	for i: int in length:
		increase_pattern_length()


# Increase the length of the pattern by 1
func increase_pattern_length() -> void:
	rand_pattern.append(randi_range(1, max_areas))
	pattern_length = rand_pattern.size()


# Prevent mouse_entered and mouse_exited from changing area colors
func toggle_area_locks() -> void:
	are_areas_locked = !are_areas_locked
	for i: int  in active_board.Areas.size():
		active_board.Areas[i].toggle_area_lock()


# Verify the user input is correct
func verify_input(input: int) -> bool:
	# Only process this if waiting for input and a rand_pattern exists
	if waiting_for_input && rand_pattern:
		# If the Area clicked matches the required area, store the input and update the score
		if int(input) == rand_pattern[next_input]:
			input_pattern.append(int(input))
			input_length = input_pattern.size()
			
			# TODO: Move scoring logic to its own function
			round_score += round(200 * input_length ** 1.1)
			score += round(200 * input_length ** 1.1)
			print("   Correct input: ", int(input), " | Round score: ", round_score, " | Total score: ", score)
			
			if next_input < pattern_length - 1:
				next_input += 1
			return true
		else:
			# TODO: Move lives-calc logic to its own function
			lives -= 1
			print("   BzzzZzZZ! Lives: ", lives)
			return false
	return false


# Calculate time user has to recite pattern
func calc_recital_time() -> void:
	recital_time = round(((teach_time + display_time) * pattern_length) + (teach_time * pattern_length))
	# If shorter than 8 seconds, allow for 8 seconds
	if recital_time < 7:
		recital_time = 7


# Calculate the player's bonus score
func calc_bonus_score() -> void:
	var bonus_points: int = int(pattern_length ** 2 * 100 + (100 * (recital_time - elapsed_time)))
	if bonus_points > 0:
		score += bonus_points
		print("   Bonus points awarded: ", bonus_points, " | New total score: ", score)


func calc_bonus_lives() -> void:
	if round_score > 10000:
		@warning_ignore("integer_division")
		lives += floor(round_score / 10000)
		if lives > 9:
			lives = 9
		print("   Bonus lives awarded | Total lives: ", lives, " / 9")
