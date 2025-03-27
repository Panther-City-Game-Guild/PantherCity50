extends Area2D

var color: String = "#141414"
var dark_pct: float = 0.3
var is_area_locked: bool = false
var mouseEntered: bool = false
var amSelected: bool = false
signal user_clicked_me


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.add_to_group("board_areas")
	dim_area()


# Called when Input events are detected
func _input(event: InputEvent) -> void:
	# If Mouse is hovering the Area and the InputEvent is a MouseButton LEFT Press
	# and the Area is not locked
	if (mouseEntered && event is InputEventMouseButton && \
	event.button_index == MOUSE_BUTTON_LEFT && \
	event.pressed && !is_area_locked):
		# signal up to the Game controller area was clicked
		emit_clicked()
		# Dim the area
		dim_area()
		# Wait 0.1 seconds and light up if still being hovered
		await get_tree().create_timer(0.1, false, false, false).timeout
		if mouseEntered && !is_area_locked:
			light_area()


# Emit the user_clicked_me signal
func emit_clicked() -> void:
	user_clicked_me.emit(int(name.get_slice("_", 1)))


# Lock this area
func lock_area() -> void:
	is_area_locked = true
	dim_area()


# Unlock this area
func unlock_area() -> void:
	is_area_locked = false
	if mouseEntered:
		light_area()


# Trigger the area
func trigger_area() -> void:
	light_area()
	await get_tree().create_timer(0.1, false, false, false).timeout
	dim_area()
	await get_tree().create_timer(0.1, false, false, false).timeout
	if mouseEntered && !is_area_locked:
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
