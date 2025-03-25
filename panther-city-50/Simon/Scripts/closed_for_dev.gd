extends Control

var dir_x: float = 1.0
var dir_y: float = 1.0

func _process(_delta: float) -> void:
	# Add a little random speed and direction to the movement
	if $Sprite2D.global_position.x <= 0: dir_x = randf_range(0.1, 2.0)
	if $Sprite2D.global_position.y <= 0: dir_y = randf_range(0.1, 2.0)
	
	if $Sprite2D.global_position.x >= 640: dir_x = randf_range(-2.0, -0.1)
	if $Sprite2D.global_position.y >= 360: dir_y = randf_range(-2.0, -0.1)
	
	$Sprite2D.global_position += Vector2(dir_x, dir_y)
	$Sprite2D.rotation_degrees += 1


func _on_return_button_button_up() -> void:
	if find_parent("GameRoot"):
		SceneManager.GoToNewSceneString(get_parent(), Scenes.GameSelection)
	else: get_tree().quit()
