extends Panel

@onready var rBtnVis: bool = false
@onready var resumeBtn := $Container/MenuContainer/ResumeBtn
@onready var newBtn := $Container/MenuContainer/NewBtn

signal view_scores

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		newBtn.grab_focus()

func set_visibility(menu: bool = false, rBtn: bool = false) -> void:
	self.visible = menu
	resumeBtn.visible = rBtn
	if rBtn:
		resumeBtn.grab_focus()


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
		view_scores.emit()


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
