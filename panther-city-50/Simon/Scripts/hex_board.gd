extends Node2D

@onready var AreaParents: Array[Area2D] = [$Area_1, $Area_2, $Area_3, $Area_4, $Area_5, $Area_6 ]
@onready var Areas: Array[Polygon2D] = [$Area_1/Polygon2D, $Area_2/Polygon2D, $Area_3/Polygon2D, $Area_4/Polygon2D, $Area_5/Polygon2D, $Area_6/Polygon2D ]

# "#FF0000" # Red
# "#FFFF00" # Yellow
# "#00FF00" # Green
# "#CC00CC" # Purple
# "#3366FF" # Blue
# "#FF9900" # Orange

### Exported Variables
@export_category("Color Settings")
@export var colors: Array[String] = [ "#FF0000", "#FFFF00", "#00FF00", "#CC00CC", "#3366FF", "#FF9900" ]
@export var dark_pct: float = 0.6 # Percent to darken the color
@export_category("Timer Settings")
@export var teach_time: float = 1.2
@export var display_time: float = 0.5
@export var recital_time: float = 25 # Number in seconds user has to recite the pattern
@export var intermission_time: float = 5 # Number of seconds before begins
@export_category("Pattern Length")
@export var pattern_length: int = 3 # Number of colors in the pattern
var rng = RandomNumberGenerator.new()
var rand_pattern: Array[int] = []
var input_pattern: Array[int] = []
var input_length: int = 0
var next_input: int = 0
var score: int = 0
var lives: int = 3
var game_on: bool = false
var waiting_for_input: bool = false
var elapsed_time: float = 0.00
var play_demo: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_variables_to_areas()
	connect_area_signals()
	if play_demo:
		demo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if waiting_for_input:
		elapsed_time += delta


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
#			print(event)
			pass


# Begin a new game
func start_game():
	play_demo = false
	
	# TODO: Create a reset_game function
	input_pattern.clear()
	rand_pattern.clear()
	score = 0
	lives = 3
	game_on = true
	game_loop()
	

func game_loop():
	# Make an initial pattern
	make_pattern(pattern_length)
	
	# Do this if the game is active
	while game_on:
		# Only do this while not waiting for user input && not between rounds
		if !waiting_for_input:
			# Determine how long user has to recite the pattern
			calculate_recital_time()
			
			# Lock Areas from mouse enter/exit events
			toggle_area_locks()
			
			await get_tree().create_timer(intermission_time).timeout
			for i in rand_pattern:
				print("  - Area: ", i + 1)
				# Light up the Area
				Areas[i].color = Color(colors[i])
			
				# Wait and then dim the Area
				await get_tree().create_timer(display_time, false, false, false).timeout
				Areas[i].color = Color(AreaParents[i].color).darkened(AreaParents[i].dark_pct)
			
				# Go to next Area
				await get_tree().create_timer(teach_time, false, false, false).timeout
				
			# Unlock Areas to mouse enter/exit events
			toggle_area_locks()
			
			# Turn timer on and wait for user input
			waiting_for_input = true
		print("Waiting for ", rand_pattern.size(), " inputs: ", elapsed_time, " / ", recital_time)
		await get_tree().create_timer(recital_time / rand_pattern.size()).timeout
		print(input_pattern)


##########   End game_loop()   ##########


# Make a random pattern x-length long
 # Used for new games and demos
func make_pattern(length):
	for i in length:
		increase_pattern_length()


# Increase the length of the pattern by 1
 # Used for new games, demos, and level increases
func increase_pattern_length():
	rand_pattern.append(rng.randi_range(0, Areas.size() - 1))
	pattern_length = rand_pattern.size()


# Calculate time user has to recite pattern
func calculate_recital_time():
	recital_time = roundi((teach_time + display_time) * rand_pattern.size()) + (teach_time * rand_pattern.size())
	if recital_time < 10:
		recital_time = 10


# Play the pattern
func play_pattern():
	# Lock Areas from mouse enter/exit events
	await get_tree().create_timer(intermission_time).timeout
	for i in rand_pattern:
		print("  - Area: ", i + 1)
		# Light up the Area
		Areas[i].color = Color(colors[i])
	
		# Wait and then dim the Area
		await get_tree().create_timer(display_time, false, false, false).timeout
		Areas[i].color = Color(AreaParents[i].color).darkened(AreaParents[i].dark_pct)
	
		# Go to next Area
		await get_tree().create_timer(teach_time, false, false, false).timeout
	# Unlock Areas to mouse enter/exit events


# Prevent mouse_entered and mouse_exited from changing area colors
	# Prevent mouse clicks from registering
func toggle_area_locks():
	for i in AreaParents.size():
		AreaParents[i].toggle_area_lock()


func verify_input(arr):
	if (int(arr[1]) - 1) == rand_pattern[next_input]:
		if next_input < pattern_length - 1:
			next_input += 1
			
			# TODO: Figure out why score is not updating!
			# TODO: Figure out why score is not updating!
			# TODO: Figure out why score is not updating!
			# TODO: Figure out why score is not updating!
		score = int(score + (500 * input_length))
		print("Score: ", score)
	else:
		lives -= 1
		print("BzzzZzZZ! Lives: ", lives)


# Calculate the player's score
func calc_bonus_score():
	var bonus_points = (pow(pattern_length, 2) * 100) + (100 * (recital_time - elapsed_time))
	score += int(score + bonus_points)
	print("Score: ", score)




# Reset the pattern(s)
 # Used for new games and demos
func reset_pattern():
	rand_pattern.clear()
	input_pattern.clear()


# Assign values to Area variables
 # Used for HexBoard setup
func assign_variables_to_areas():
	var i = 0
	for Area in Areas:
		Area.get_parent().color = colors[i]
		Area.get_parent().dark_pct = dark_pct
		Area.get_parent().update_area()
		i += 1


# Connect to Area signals
func connect_area_signals():
	for Parent in AreaParents:
		Parent.connect("user_clicked_me", verify_input)


# Play a Demo for the user
func demo():
	print("-- Begin Demo")
	reset_pattern()
	print(" - Make Pattern")
	make_pattern(3)
	calculate_recital_time()
	print(" - Play Pattern")
	play_pattern()
	print(" - Time until next demo: ", recital_time)
	get_tree().create_timer(30).connect("timeout", demo)
