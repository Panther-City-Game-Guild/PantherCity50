extends Panel

@onready var rBtnVis: bool = false
@onready var resumeBtn := $Container/MenuContainer/ResumeBtn
@onready var newBtn := $Container/MenuContainer/NewBtn

signal resume_game
signal new_game
signal back_to_selection
signal view_scores
signal exit

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
	if Input.is_action_just_pressed("ui_accept") || (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		resume_game.emit()


# New Game Button -- Emit signal to begin a new game
func _on_new_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		new_game.emit()


# High Scores Button -- Emit signal to view the high scores
func _on_scores_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		view_scores.emit()


# Game Selection Button -- Emit signal to return to game selection menu
func _on_return_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		back_to_selection.emit()


# Exit Button -- Emit signal to close the application
func _on_exit_btn_gui_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_accept") || (event is InputEventMouseButton && event.pressed && event.button_index == MOUSE_BUTTON_LEFT):
		exit.emit()
