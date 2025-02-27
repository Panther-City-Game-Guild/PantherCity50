extends Area2D

@export var color: String = "#141414"
var dark_pct: float = 0.3
var is_area_locked: bool = false
var mouseEntered: bool = false
var amSelected: bool = false
signal user_clicked_me


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dim_area()


# Called when Input events are detected
func _input(event: InputEvent) -> void:
	# TODO: Move logic here to check for "trigger_ability_x" input actions
	# TODO: Or move click detection logic to HexBoard***
	# CHECK FOR MOUSE INPUT
		# CHECK FOR "mouseEntered" to select the correct area and the event was left mouse button click
			# Dim area for a time
				# If mouse still in the area, light the area back up
	
	if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		if mouseEntered && !is_area_locked:
			user_clicked_me.emit(int(name.get_slice("_", 1)))
			dim_area()
			if mouseEntered:
				await get_tree().create_timer(0.1).timeout
				light_area()


# Toggle the lock on this area
func toggle_area_lock() -> void:
	is_area_locked = !is_area_locked
	if is_area_locked:
		dim_area()
	if mouseEntered && !is_area_locked:
		light_area()


func trigger_area() -> void:
	light_area()
	await get_tree().create_timer(0.1).timeout
	dim_area()
	if mouseEntered:
		await get_tree().create_timer(0.1).timeout
		light_area()


# Lighten the Area
func light_area() -> void:
	$Polygon2D.color = Color(color)


# Dim the Area
func dim_area() -> void:
	$Polygon2D.color = Color(color).darkened(dark_pct)


# Mouse Entered Area
func _on_mouse_entered() -> void:
	mouseEntered = true
	if !is_area_locked:
		light_area()


# Mouse Exited Area
func _on_mouse_exited() -> void:
	mouseEntered = false
	if !is_area_locked:
		dim_area()
