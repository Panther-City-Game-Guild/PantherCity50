extends Node2D

### Handles to Area Parents; children
# TODO: Renumber Areas to start with 0
# TODO: Refactor code to support this renaming
@onready var AreaParents: Array[Area2D] = [
	$Area_1, $Area_2, $Area_3,
	$Area_4, $Area_5, $Area_6 ]

### Handles to Areas; grandchildren
# TODO: Renumber Areas to start with 0
# TODO: Refactor code to support this renaming
@onready var Areas: Array[Polygon2D] = [
	$Area_1/Polygon2D, $Area_2/Polygon2D,
	$Area_3/Polygon2D, $Area_4/Polygon2D,
	$Area_5/Polygon2D, $Area_6/Polygon2D ]

### Exported Variables
# Color Settings
@export_category("Color Settings")
@export var colors: Array[String] = [ # Array of color codes for the clickable Areas
	"#FF0000",	# 0 Red
	"#FFFF00",	# 1 Yellow
	"#00FF00",	# 2 Green
	"#CC00CC",	# 3 Purple
	"#3366FF",	# 4 Blue
	"#FF9900" ]	# 5 Orange
@export var dark_pct: float = 0.6 # Percent to darken the color
# Timer Durations
@export_category("Timer Settings")
@export var teach_time: float = 0.5 # Number of seconds between lighting different Areas during teaching
@export var display_time: float = 0.5 # Number of seconds to keep an area lit during teaching
@export var recital_time: float = 10 # Number of seconds user has to recite the pattern (before being penalized)
@export var intermission_time: float = 5 # Number of seconds before round begins
# Pattern Settings
@export_category("Pattern Length")
@export var pattern_length: int = 3 # Default number of colors in the rand_pattern

### Non-Exported Variables
var rng: RandomNumberGenerator = RandomNumberGenerator.new() # Generic RandomNumberGenerator
var rand_pattern: Array[int] = [] # Store the randomly generated color pattern
var input_pattern: Array[int] = [] # Store the user's recited pattern
var input_length: int = 0 # Length of the user's input pattern
var next_input: int = 0 # Which input index is expected next
var lives: int = 3 # The player's lives, default 3
var score: int = 0 # The player's score
var round_score: int = 0 # The player's score from this round
var game_on: bool = false # Is a game in progress?
var waiting_for_input: bool = false # Are we waiting for user input?
var has_pattern_played: bool = false # Has the user seen the pattern this round?
var are_areas_locked: bool = false # Are the clickable Areas locked?
var in_intermission: bool = false # Are we between rounds?
var elapsed_time: float = 0.00 # How long the user has taken to give input
var play_demo: bool = false # Should the Demo play?


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Color the Areas according to settings
	assign_variables_to_areas() # Depends on colors and dark_pct
	
	# Connect to signals emitted by the Areas
	connect_area_signals() # Depends on AreaParents


### Begin Game Loop
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Are we waiting for user input?
	if waiting_for_input:
		# If so, increase the elapsed_time
		elapsed_time += delta
	
	# If a game is in progress . . .
	if game_on && !in_intermission:
		
		# If the user has not seen the pattern this round, show them
		if !has_pattern_played:
			has_pattern_played = true
			
			# Lock the clickable color areas
			toggle_area_locks()
			
			# After the intermission time, show the pattern to the user
			# TODO: Add a Round Start countdown timer to the UI
			print(" Round begins in ", intermission_time, " seconds! --")
			print("   Pattern: ", rand_pattern)
			await get_tree().create_timer(intermission_time).timeout
			for i in rand_pattern:
				# Light up the Area
				Areas[i].color = Color(colors[i])
				
				# Wait and then dim the Area
				await get_tree().create_timer(display_time, false, false, false).timeout
				Areas[i].color = Color(AreaParents[i].color).darkened(AreaParents[i].dark_pct)
				
				# Go to next Area
				await get_tree().create_timer(teach_time, false, false, false).timeout
			
			# Unlock the clickable color areas and wait for user input
			toggle_area_locks()
			waiting_for_input = true
		
		# If the user clicked enough correct colors
		if input_length == pattern_length:
			waiting_for_input = false
			print("  Round completed in ", floor(elapsed_time), " seconds!")
			in_intermission = true
			calc_bonus_score()
			calc_bonus_lives()
			
			# TODO: Make a screen with recap and button for leveling up!
			level_up()
			
### End Game Loop


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
		
		# Start the game
		print("Starting a new game")
		game_on = true


# Called to reset all game variables
func reset_game() -> bool:
	game_on = false
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
	
	# Increase the pattern by 1 color
	increase_pattern_length()


# Called when showing scores between rounds
func pause_loop() -> void:
	in_intermission = true


# Generate a rand_pattern to teach the player
func make_pattern(length: int) -> void:
	for i: int in length:
		increase_pattern_length()


# Increase the length of the pattern by 1
func increase_pattern_length() -> void:
	rand_pattern.append(rng.randi_range(0, Areas.size() - 1))
	pattern_length = rand_pattern.size()


# Calculate time user has to recite pattern
func calc_recital_time() -> void:
	recital_time = roundi((teach_time + display_time) * pattern_length) + (teach_time * pattern_length)
	# If shorter than 10 seconds, allow for 10 seconds
	if recital_time < 10:
		recital_time = 10


# Prevent mouse_entered and mouse_exited from changing area colors
func toggle_area_locks() -> void:
	for i in AreaParents.size():
		AreaParents[i].toggle_area_lock()


# Verify the user input is correct
func verify_input(input) -> void:
	# Only process this if waiting for input and a rand_pattern exists
	if waiting_for_input && rand_pattern:
		# If the Area clicked matches the required area, store the input and update the score
		if int(input) - 1 == rand_pattern[next_input]:
			input_pattern.append(int(input) - 1)
			input_length = input_pattern.size()
			round_score += 500 * input_length
			score += 500 * input_length
			print("   Correct input: ", int(input)  - 1, " | Round score: ", round_score, " | Total score: ", score)
			
			if next_input < pattern_length - 1:
				next_input += 1
			
		else:
			lives -= 1
			print("   BzzzZzZZ! Lives: ", lives)


# Calculate the player's bonus score
func calc_bonus_score() -> void:
	var bonus_points: int = int(pattern_length ** 2 * 100 + (100 * (recital_time - elapsed_time)))
	if bonus_points > 0:
		score += bonus_points
		print("   Bonus points awarded: ", bonus_points, " | New total score: ", score)


func calc_bonus_lives() -> void:
	if round_score > 10000:
		lives += floor(round_score / 10000)
		if lives > 9:
			lives = 9
		print("   Bonus lives awarded | Total lives: ", lives, " / 9")


# Assign values to Area variables
 # Used for HexBoard setup
func assign_variables_to_areas() -> void:
	var i := 0
	for Area in Areas:
		Area.get_parent().color = colors[i]
		Area.get_parent().dark_pct = dark_pct
		Area.get_parent().update_area()
		i += 1


# Connect to Area signals
func connect_area_signals() -> void:
	for Parent in AreaParents:
		Parent.connect("user_clicked_me", verify_input)


# Play a Demo for the user
#func demo():
	#print("-- Begin Demo")
	#reset_pattern()
	#print(" - Make Pattern")
	#make_pattern(3)
	#calculate_recital_time()
	#print(" - Play Pattern")
	#play_pattern()
	#print(" - Time until next demo: ", recital_time)
	#get_tree().create_timer(30).connect("timeout", demo)
