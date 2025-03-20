extends Control


# Called every render frame
func _process(_delta: float) -> void:
	if owner.is_game_running:
		update_timer()

# Called to update lives counter display
func update_lives(i: int) -> void:
	$PanelContainer/Rows/Row1/LivesHBox/LivesData.text = str(i)

# Called to update the score counter display
func update_score(i: int) -> void:
	$PanelContainer/Rows/Row1/ScoreHBox/ScoreData.text = str(i)

# Called to update the timer display
func update_timer() -> void:
	var m: int = floori(owner.GameClock.time_left / 60)
	var s: int = floori(owner.GameClock.time_left - (m * 60))
	$PanelContainer/Rows/Row1/TimeHBox/TimeData.text = str(m).pad_zeros(2) + ":" + str(s).pad_zeros(2)

# Called to update the prompt
func update_prompt(txt: String) -> void:
	$PanelContainer/Rows/Row2/PromptData.text = txt
