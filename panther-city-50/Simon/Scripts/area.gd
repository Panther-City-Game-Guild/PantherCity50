extends Area2D

@export var color = "#141414"
@export var dark_pct: float = 0.3
var is_pattern_playing: bool = false


# Update based on variables
func update_area():
	$Polygon2D.color = Color(color).darkened(dark_pct)

# Mouse Entered Area
func _on_mouse_entered() -> void:
	if !is_pattern_playing:
		$Polygon2D.color = Color(color)

# Mouse Exited Area
func _on_mouse_exited() -> void:
	if !is_pattern_playing:
		$Polygon2D.color = Color(color).darkened(dark_pct)
