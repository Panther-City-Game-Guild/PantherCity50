extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to_file(Scenes.GameRootScene)
