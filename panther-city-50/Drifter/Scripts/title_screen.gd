extends Node2D	


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_parent().name == "GameRoot":
			SceneManager.GoToNewSceneString(self, Scenes.GameSelection)
		else:
			get_tree().quit()
			
	if Input.is_action_just_pressed("ui_accept"):
		SceneManager.GoToNewSceneString(self, Scenes.DrifterPlay)
