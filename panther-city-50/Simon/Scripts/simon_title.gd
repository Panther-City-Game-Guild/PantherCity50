extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HexBoard.play_demo = true
	$TitlePanel/Container/MenuContainer/NewBtn.grab_focus()

# Called when input events happen
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		_on_return_btn_button_up()


# New Game Button UP -- Start a new game
func _on_new_btn_button_up() -> void:
	$TitlePanel.visible = false
	$SimonHUD.visible = true
	$HexBoard.start_game()


# Return Button UP -- Returrn to Game Selection screen
func _on_return_btn_button_up() -> void:
	if get_parent().name == "GameRoot":
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)


# Exit Game Button UP -- Close the application
func _on_exit_btn_button_up() -> void:
	get_tree().quit()


# Triggered when SimonTitle is being removed from the SceneTree
# E.g., Triggered when returning to Game Selection
func _on_tree_exiting() -> void:
	print("SimonTitle exiting scene tree")


func _on_texture_button_button_up() -> void:
	print("TextButton clicked")
