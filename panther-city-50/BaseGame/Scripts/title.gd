extends Node2D

# Called when input events are detected
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(Scenes.GameRootScene)
