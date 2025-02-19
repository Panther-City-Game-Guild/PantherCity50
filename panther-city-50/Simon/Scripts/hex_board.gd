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
@export var teach_time: float = 1.5
@export var display_time: float = 0.5
@export var recital_time: float = 25 # Number in seconds user has to recite the pattern
@export_category("Pattern Length")
@export var pattern_length: int = 3 # Number of colors in the pattern
var rand_pattern: Array[int] = []
var input_pattern: Array[int] = []
var level: int = 1
var score: int = 0
var do_over: int = 0
var recital_timer: Timer = Timer.new()
var rng = RandomNumberGenerator.new()
var play_demo: bool = true

# recital time = ((teach_time + display_time) * pattern_length) + (teach_time * pattern_length)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assign_variables_to_areas()
	demo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Begin a new game
func start_game():
	# Make a random pattern
	make_pattern(pattern_length)
	play_pattern()


# Make a random pattern x-length long
func make_pattern(length):
	print("- Making pattern")
	for i in length:
		rand_pattern.append(rng.randi_range(0, colors.size() - 1))


# Play the pattern
func play_pattern():
	for Area in AreaParents:
		Area.is_pattern_playing = true
	
	print("- Playing pattern")
	for i in rand_pattern:
		change_area_color(i)
		await get_tree().create_timer(teach_time, false, false, false).timeout
		
	for Area in AreaParents:
		Area.is_pattern_playing = false


# Change an Area's color
func change_area_color(i):
	print(i, ":\n   Changing color")
	Areas[i].color = Color(colors[i])
	await get_tree().create_timer(display_time, false, false, false).timeout
	print("   Reverting color")
	Areas[i].color = Color(colors[i]).darkened(dark_pct)


# Record user input
func record_input():
	input_pattern.append(1)
# TODO : Record input events -- move to _process


# Reset the pattern(s)
func reset_pattern():
	rand_pattern.clear()
	input_pattern.clear()


# Assign values to Area variables (Setup)
func assign_variables_to_areas():
	var i = 0
	for AreaParent in AreaParents:
		AreaParent.color = colors[i]
		AreaParent.dark_pct = dark_pct
		AreaParent.update_area()
		i += 1

# Play the Demo for the user
func demo():
	print("--- Beginning demo ---")
	reset_pattern()
	await get_tree().create_timer(5).timeout
	make_pattern(8)
	play_pattern()
	recital_time = ((teach_time + display_time) * rand_pattern.size()) + (teach_time * rand_pattern.size())
	get_tree().create_timer(recital_time).connect("timeout", demo)
