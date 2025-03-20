extends Node2D

### Handles to Areas; children
@onready var Areas: Array[Area2D] = [
	$BoardSprite/Area_1, $BoardSprite/Area_2, $BoardSprite/Area_3,
	$BoardSprite/Area_4, $BoardSprite/Area_5, $BoardSprite/Area_6 ]

### Handles to AreaPolygons; grandchildren
@onready var AreaPolygons: Array[Polygon2D] = [
	$BoardSprite/Area_1/Polygon2D, $BoardSprite/Area_2/Polygon2D,
	$BoardSprite/Area_3/Polygon2D, $BoardSprite/Area_4/Polygon2D,
	$BoardSprite/Area_5/Polygon2D, $BoardSprite/Area_6/Polygon2D ]

func _ready() -> void:
	# Assign the correct colors to the Board's AreaPolygons
	assign_variables_to_areas()
	# Connect the Area signals to the Game controller
	connect_area_signals()

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

func trigger_area(i: int) -> void:
	Areas[i].trigger_area()

func light_area(i: int) -> void:
	Areas[i].light_area()

func dim_area(i: int) -> void:
	Areas[i].dim_area()
