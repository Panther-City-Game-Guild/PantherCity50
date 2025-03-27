extends Node2D

var Areas: Array[Area2D] = [] # Handles to Areas; children
var AreaPolygons: Array[Polygon2D] = [] # Handles to AreaPolygons; grandchildren
var board_type: int = 0 # Hexagon 0, Circle 1, Diamond 2, Triangle 3
var are_areas_locked: bool = false # Should the areas receive input?

func _ready() -> void:
	global_position = Vector2(get_viewport().get_visible_rect().size / 2)
	
	# Find handles to Areas
	for Area in $BoardSprite.get_children():
		Areas.append(Area)
	
	# Find handles to AreaPolygons
	for Area in Areas:
		AreaPolygons.append(Area.get_node("Polygon2D"))


### Begin InputEvent Checks
func _input(event: InputEvent) -> void:
	# If a game is in progress and the areas are not locked
	if owner.is_game_running && !are_areas_locked:
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
		if i >= 1 && i <= owner.max_areas:
			trigger_area(i - 1)
			Areas[i-1].emit_clicked()
### End InputEvent Checks


# Assign values to Area variables
func assign_variables_to_areas() -> void:
	# 0 Red, 1 Yellow, 2 Green, 3 Purple, 4 Blue, 5 Orange
	var colors: Array[String] = owner.area_colors.duplicate()
	if board_type != 0:
		colors.clear()
	
	if board_type == 1: # Circle = Green 2, Red 0, Blue 4, Yellow 1
		colors = [ owner.area_colors[2], owner.area_colors[0], owner.area_colors[4], owner.area_colors[1] ]
	
	elif board_type == 2: # Diamond = Red 0, Blue 4, Yellow 1, Green 2
		colors = [ owner.area_colors[0], owner.area_colors[4], owner.area_colors[1], owner.area_colors[2] ]
	
	elif board_type == 3: # Triangle = Blue 4, Green 2, Red 0
		colors = [ owner.area_colors[4], owner.area_colors[2], owner.area_colors[0] ]
	
	for i: int in AreaPolygons.size():
		Areas[i].color = colors[i]
		Areas[i].dark_pct = owner.dark_pct
		Areas[i].dim_area()


# Connect to Area signals
func connect_area_signals() -> void:
	if owner.has_method("verify_input"):
		for Area in Areas:
			Area.connect("user_clicked_me", owner.verify_input)


# Triger an Area (dim and then light up)
# A relay between the Game manager and the Areas
func trigger_area(i: int) -> void:
	Areas[i].trigger_area()


# Called to make all Areas illuminate at once
# used when the board unlocks for user input
# used during new Game start
func flash_areas() -> void:
	get_tree().call_group("board_areas", "trigger_area")
	await get_tree().create_timer(0.2, false, false, false).timeout


# Called to create a chase effect with the Areas
# used during new Game start
func chase_areas(sequence: Array[int]) -> void:
	var x: int = 0
	for i in sequence:
		Areas[i].trigger_area()
		if x < sequence.size() - 1:
			await get_tree().create_timer(0.1, false, false, false).timeout


# Light up an Area
# A relay between the Game manager and the Areas
func light_area(i: int) -> void:
	Areas[i].light_area()


# Dim an Area
# A relay between the Game manager and the Areas
func dim_area(i: int) -> void:
	Areas[i].dim_area()


# Lock all Areas at one time
func lock_areas() -> void:
	are_areas_locked = true
	get_tree().call_group("board_areas", "lock_area")


# Unlock all Areas at one time
func unlock_areas() -> void:
	are_areas_locked = false
	get_tree().call_group("board_areas", "unlock_area")
