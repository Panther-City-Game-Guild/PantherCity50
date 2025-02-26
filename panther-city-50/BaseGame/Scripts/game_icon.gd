extends Button

@export var GameTitleScene: PackedScene
@export var ButtonTexture: Texture
signal startGame(gameToStart: PackedScene)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && GameTitleScene != null:
		startGame.emit(GameTitleScene)
	
	if Input.is_action_just_pressed("ui_accept") && GameTitleScene != null:
		startGame.emit(GameTitleScene)
