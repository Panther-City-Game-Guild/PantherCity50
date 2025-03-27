extends Panel

var LogoBoard: CompressedTexture2D = load("res://Simon/Assets/SimonHexboard.png")
@onready var NameBoard := $Container/Sprite2D
@onready var resumeBtn := $Container/MenuContainer/ResumeBtn
@onready var newBtn := $Container/MenuContainer/NewBtn


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var img: Image = LogoBoard.get_image()
	img.resize(32, 32)
	var texture: ImageTexture = ImageTexture.create_from_image(img)
	NameBoard.texture = texture
	
	newBtn.grab_focus()


# Toggle the GameMenu's visibility
func toggle_game_menu(b: bool) -> void:
	self.visible = b


# Toggle the GameMenu's Resume Button's visibility
func toggle_resume_button(b: bool) -> void:
	resumeBtn.visible = b
	if b:
		newBtn.release_focus()
		resumeBtn.grab_focus()
	if !b:
		resumeBtn.release_focus()
		newBtn.grab_focus()

# Resume Game Button -- Emit signal to resume the already running game
func _on_resume_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || \
	Input.is_action_just_pressed("ActionButton") || \
	(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		if owner.has_signal("unpause_game"):
			owner.unpause_game.emit()


# New Game Button -- Emit signal to begin a new game
func _on_new_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || \
	Input.is_action_just_pressed("ActionButton") || \
	(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		if owner.has_signal("new_game"):
			owner.new_game.emit()


# High Scores Button -- Emit signal to view the high scores
func _on_scores_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || \
	Input.is_action_just_pressed("ActionButton") || \
	(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		if owner.has_signal("view_scores"):
			owner.view_scores.emit()


# Game Selection Button -- Emit signal to return to game selection menu
func _on_return_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || \
	Input.is_action_just_pressed("ActionButton") || \
	(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		if owner.has_signal("back_to_selection"):
			owner.back_to_selection.emit()


# Exit Button -- Emit signal to close the application
func _on_exit_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || \
	Input.is_action_just_pressed("ActionButton") || \
	(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		if owner.has_signal("exit"):
			owner.exit.emit()


# TODO: Make this detect which button received the gui input and do code based on that, to eliminate the repetitive code above
func _on_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") || \
	event.is_action_pressed("ActionButton") || \
	(event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		pass
