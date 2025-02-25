extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HexBoard.play_demo = true


# Called when input events happen
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_quit_btn_button_up()
		
	if Input.is_action_just_pressed("ui_accept"):
		SceneManager.GoToNewSceneString(self, Scenes.SimonTitle)

# New Game Button UP
func _on_new_btn_button_up() -> void:
	$TitlePanel.visible = false
	$HexBoard.start_game()

# Quit Game Button UP
 # Scene Tree checking for running this Scene as a standalone during development
 # Can remove checking after development is complete
func _on_quit_btn_button_up() -> void:
	if get_parent().name == "GameRoot":
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)
	else:
		get_tree().quit()
