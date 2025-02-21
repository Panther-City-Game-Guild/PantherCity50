extends Area2D

var color: String = "#141414"
var dark_pct: float = 0.3
var is_area_locked: bool = false
var mouseEntered = false
signal user_clicked_me

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called when Input events are detected
func _input(event: InputEvent) -> void:
	if mouseEntered:
		if (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
			user_clicked_me.emit(name.get_slice("_", 1))


# Toggle the lock on this area
func toggle_area_lock():
	is_area_locked = !is_area_locked
	update_area()


# Update based on variables
func update_area():
	$Polygon2D.color = Color(color).darkened(dark_pct)


# Mouse Entered Area
func _on_mouse_entered() -> void:
	mouseEntered = true
	if !is_area_locked:
		$Polygon2D.color = Color(color)


# Mouse Exited Area
func _on_mouse_exited() -> void:
	mouseEntered = false
	if !is_area_locked:
		$Polygon2D.color = Color(color).darkened(dark_pct)
