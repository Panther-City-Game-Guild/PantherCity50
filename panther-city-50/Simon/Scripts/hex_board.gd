extends Node2D


### Handles to Areas; children
@onready var Areas: Array[Area2D] = []

### Handles to AreaPolygons; grandchildren
@onready var AreaPolygons: Array[Polygon2D] = []


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
	if owner.is_game_running:
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
	# 1 Red, 2 Yellow, 3 Green, 4 Purple, 5 Blue, 6 Orange
	for i: int in AreaPolygons.size():
		Areas[i].color = owner.area_colors[i]
		Areas[i].dark_pct = owner.dark_pct
		Areas[i].dim_area()


# Connect to Area signals
func connect_area_signals() -> void:
	for Area in Areas:
		Area.connect("user_clicked_me", owner.verify_input)


# Triger an Area (dim and then light up)
# A relay between the Game manager and the Areas
func trigger_area(i: int) -> void:
	Areas[i].trigger_area()


func flash_areas() -> void:
	get_tree().call_group("board_areas", "trigger_area")


# Light up an Area
# A relay between the Game manager and the Areas
func light_area(i: int) -> void:
	Areas[i].light_area()


# Dim an Area
# A relay between the Game manager and the Areas
func dim_area(i: int) -> void:
	Areas[i].dim_area()
