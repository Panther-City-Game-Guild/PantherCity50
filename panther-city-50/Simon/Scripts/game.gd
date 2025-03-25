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
@export var recital_time: float = 4.0 # Number of seconds user has to recite the pattern
@export var min_recital_time: float = 4.0 # Minimum number of seconds user has to recite pattern
@export var intermission_time: float = 1.5 # Number of seconds before round begins
@export var pattern_length: int = 1 # Number of colors in the rand_pattern; default 1
@export_category("Board Settings")
@export_enum("Hexagon", "Circle", "Diamond", "Triangle") var selected_board: int = 0

### Non-Exported Variables
# Game Child Nodes
@onready var GameBoards: Array[PackedScene] = [ # TODO: Alter these as new boards get implemented
	preload("res://Simon/Scenes/HexBoard.tscn"),
	preload("res://Simon/Scenes/HexBoard.tscn"),
	preload("res://Simon/Scenes/HexBoard.tscn"),
	preload("res://Simon/Scenes/HexBoard.tscn") ]
@onready var GameClock: Timer = $GameClock
@onready var GameHUD: Control = $GameHUD
# Other Variables
var active_board: Node2D # Which board is currently being used
var max_areas: int = 6 # How many areas does the active_board have
var rand_pattern: Array[int] = [] # Store the randomly generated color pattern
var input_pattern: Array[int] = [] # Store the user's recited pattern
var input_length: int = 0 # Length of the user's input pattern
var next_input: int = 0 # Which input index is expected next
var level: int = 1 # Which level the userr is currently on
var lives: int = 3 # The player's lives, default 3
var score: int = 0 # The player's score
var round_score: int = 0 # The player's score from this round
var is_game_running: bool = false # Is a game in progress?
var waiting_for_input: bool = false # Are we waiting for user input?
var has_pattern_played: bool = false # Has the user seen the pattern this round?
var has_round_started: bool = false
var are_areas_locked: bool = false # Are the clickable Areas locked?
var in_intermission: bool = false # Are we between rounds?
var elapsed_time: float = 0.00 # How long the user has taken to give input
var play_demo: bool = false # Should the Demo play?
var area_triggered: int = -1 # Which area is triggered; 0-5, -1 for none


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameHUD.visible = false
	GameHUD.update_lives(lives)
	GameHUD.update_score(score)


### Begin Game Loop
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If a game is in progress . . .
	if is_game_running && !in_intermission:
		
		# Has the player lost all their lives?
		if lives <= 0:
			game_over("died")
			return
		
		# Are we waiting for user input?
		if waiting_for_input:
			# If so, increase the elapsed_time
			elapsed_time += delta
			# If elapsed time >= recital_time, end the game
			if elapsed_time >= recital_time:
				game_over("timesup")
				return
		
		# If the user has not seen the pattern this round, show them
		if !has_pattern_played:
			has_pattern_played = true
			print(" Round begins in ", intermission_time, " seconds!")
			GameHUD.set_time_data()
			await get_tree().create_timer(intermission_time).timeout
			print("  Pattern length: ", pattern_length, " | Recital time: ", recital_time)
			print("  Pattern: ", rand_pattern)
			
			# Lock the clickable color areas
			lock_areas()
			active_board.set_process_input(false)
			
			# Teach the pattern
			for i: int in rand_pattern:
				# Light up the Area
				active_board.light_area(i - 1)
				
				# Wait and then dim the Area
				await get_tree().create_timer(display_time, false, false, false).timeout
				active_board.dim_area(i - 1)
				
				# Go to next Area
				await get_tree().create_timer(teach_time, false, false, false).timeout
			
			# Unlock the clickable color areas and wait for user input
			await get_tree().create_timer(intermission_time).timeout
			active_board.flash_areas()
			await get_tree().create_timer(0.1).timeout
			unlock_areas()
			active_board.set_process_input(true)
			waiting_for_input = true
			GameHUD.flash_time_data()
			GameClock.start(recital_time)
		
		# If the user clicked enough correct colors (round is over)
		if input_length == pattern_length:
			waiting_for_input = false
			print("  Round completed in ", floor(elapsed_time), " / ", recital_time, " seconds!")
			in_intermission = true
			calc_bonus_score()
			calc_bonus_lives()
			
			# If the pattern length is less than 10, go to the next round
			if pattern_length < 10:
				next_round()
				return
			
			# If the pattern_length is 10
			if pattern_length == 10:
				# If the level is less than 10, go to the next level
				if level < 10:
					# TODO: Make a screen with recap and button for leveling up!
					next_level()
					return
				# Otherwise, the game is won
				else:
					# TODO: Make a screen with recap and button for playing again!
					game_over("won")
					return
### End Game Loop


# Set the active board based on settings (HexBoard by default)
func set_active_board() -> void:
	# TODO: Alter these as new boards get implemented
	if selected_board == 0:
		active_board = GameBoards[selected_board].instantiate() # Hexagon
		max_areas = 6
	if selected_board == 1:
		active_board = GameBoards[selected_board].instantiate() # Circle
		max_areas = 4
	if selected_board == 2:
		active_board = GameBoards[selected_board].instantiate() # Diamond
		max_areas = 4
	if selected_board == 3:
		active_board = GameBoards[selected_board].instantiate() # Triangle
		max_areas = 3
	# Add the active_board to the scene tree
	add_child(active_board)
	active_board.owner = self
	# Assign the correct colors to the Board's AreaPolygons
	active_board.assign_variables_to_areas()
	# Connect the Area signals to the Game controller
	active_board.connect_area_signals()


# Begin a new game
func start_game() -> void:
	# If a previous board exists, remove it from the tree
	if active_board:
		remove_child(active_board)
	
	# Reset all game parameters
	reset_game()
	
	# Generate a rand_pattern to teach the player
	make_pattern(pattern_length)

	# Calculate time user has to recite pattern
	calc_recital_time() # Depends on teach_time, display_time, and pattern_length
	
	# Use settings to determine which board is needed
	set_active_board()
	
	# Display the GameHUD and Board
	GameHUD.visible = true
	active_board.visible = true
	
	# Start the game
	print("Starting a new game")
	is_game_running = true


# Called to reset all game variables
func reset_game() -> void:
	is_game_running = false
	waiting_for_input = false
	has_pattern_played = false
	are_areas_locked = false
	in_intermission = false
	pattern_length = 1
	input_length = 0
	next_input = 0
	elapsed_time = 0
	level = 1
	lives = 3
	score = 0
	round_score = 0
	rand_pattern.clear()
	input_pattern.clear()
	GameClock.stop()


# Called to reset variables for the game's next round
func next_round() -> void:
	waiting_for_input = false
	has_pattern_played = false
	are_areas_locked = false
	in_intermission = false
	input_length = 0
	next_input = 0
	elapsed_time = 0
	round_score = 0
	GameClock.stop()
	input_pattern.clear()
	increase_pattern_length()
	calc_recital_time()


# Called to reset variables for the game's next level
func next_level() -> void:
	waiting_for_input = false
	has_pattern_played = false
	are_areas_locked = false
	in_intermission = false
	input_length = 0
	next_input = 0
	elapsed_time = 0
	round_score = 0
	level += 1
	teach_time -= 0.1
	display_time -= 0.05
	GameClock.stop()
	input_pattern.clear()
	pattern_length = 1
	make_pattern(pattern_length)
	calc_recital_time()


# Called when the game is over for various reasons
func game_over(why: String) -> void:
	is_game_running = false
	waiting_for_input = false
	are_areas_locked = true
	GameClock.stop()
	if why == "timesup":
		print("Testing failed: Player ran out of time!")
		# TODO: Make GameHUD explain testing failed
		# GameHUD.testing_failed()
	elif why == "died":
		# TODO: Make GameHUD explain player lost all lives
		# GameHUD.player_died()
		print("Testing failed: Player lost all lives!")
	else:
		print("Player won!")
		# TODO: Make GameHUD explain player won the game
		# GameHUD.game_won()


# Called when showing scores between rounds
func pause_loop() -> void:
	in_intermission = !in_intermission


# Generate a rand_pattern to teach the player
func make_pattern(length: int) -> void:
	rand_pattern.clear()
	for i: int in length:
		increase_pattern_length()


# Increase the length of the pattern by 1
func increase_pattern_length() -> void:
	rand_pattern.append(randi_range(1, max_areas))
	pattern_length = rand_pattern.size()


# Lock the active_board Areas
func lock_areas() -> void:
	are_areas_locked = true
	for i: int  in active_board.Areas.size():
		active_board.Areas[i].lock_area()


# Unlock the active_board Areas
func unlock_areas() -> void:
	are_areas_locked = false
	for i: int  in active_board.Areas.size():
		active_board.Areas[i].unlock_area()


# Verify the user input is correct
func verify_input(input: int) -> bool:
	# Only process this if waiting for input and a rand_pattern exists
	if waiting_for_input && rand_pattern:
		# If the input was correct, store the input and update the score
		if int(input) == rand_pattern[next_input]:
			input_pattern.append(int(input))
			input_length = input_pattern.size()
			increase_score()
			
			if next_input < pattern_length - 1:
				next_input += 1
			return true
		# If input was incorrect, take away a life
		else:
			lives -= 1
			GameHUD.update_lives(lives)
			GameHUD.lives_hint_show(-1)
			return false
	return false


# Calculate time user has to recite pattern
func calc_recital_time() -> void:
	recital_time = roundf(min_recital_time + pattern_length ** 0.5)


# Add points to the player's score
func increase_score() -> void:
	var points: int = round(200 * input_length ** 1.1)
	round_score += points
	score += points
	GameHUD.add_score_hint(points)
	print("   Points Added: ", points, " | Round score: ", round_score, " | Total score: ", score)


# Calculate the player's bonus score
func calc_bonus_score() -> void:
	var bonus_points: int = int(pattern_length ** 2 * 100 + (100 * (recital_time - elapsed_time)))
	if bonus_points > 0:
		score += bonus_points
		GameHUD.add_score_hint(bonus_points)
		print("   Bonus points awarded: ", bonus_points, " | New total score: ", score)


# Reward additional lives to the player
func calc_bonus_lives() -> void:
	if round_score > 7500:
		var b_lives: int = 0
		b_lives = floori(round_score / 7500.0)
		if lives + b_lives >= 9:
			lives = 9
		else:
			lives += b_lives
			GameHUD.lives_hint_show(b_lives)

		
		# Update the GameHUD
		GameHUD.update_lives(lives)
		print("   Bonus lives earned: ", b_lives, " | Total lives: ", lives, " / 9")
