extends Node2D


# Called when input events are detected
func _input(_event: InputEvent) -> void:
	if _event.is_action_pressed("StartButton"):
		get_tree().change_scene_to_file(Scenes.GameRootScene)
