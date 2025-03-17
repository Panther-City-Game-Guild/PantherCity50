extends Control

# Called every render frame
func _process(_delta: float) -> void:
	pass
	if owner.game_on && owner.GameClock:
		update_timer()

# Called to update lives counter display
func update_lives() -> void:
	if owner.lives:
		$PanelContainer/Rows/Row1/LivesHBox/LivesData.text = owner.lives

# Called to update the score counter display
func update_score() -> void:
	if owner.score:
		$PanelContainer/Rows/Row1/ScoreHBox/ScoreData.text = owner.score

# Called to update the timer display
func update_timer() -> void:
	if owner.GameClock:
		var m: int = floori(owner.GameClock.time_left / 60)
		var s: int = floori(owner.GameClock.time_left - (m * 60))
		$PanelContainer/Rows/Row1/TimeHBox/TimeData.text = str(m).pad_zeros(2) + ":" + str(s).pad_zeros(2)

# Called to update the prompt
func update_prompt() -> void:
	if owner.prompt_text:
		$PanelContainer/Rows/Row2/PromptData.text = owner.prompt_text
