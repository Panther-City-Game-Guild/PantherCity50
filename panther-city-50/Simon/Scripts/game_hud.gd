extends Control

@onready var score_color_timer: Timer = $ScoreDataColorTimer
@onready var lives_hint_timer: Timer = $LivesHintTimer
@onready var lives_data: Label = $PanelContainer/Rows/Row1/LivesHBox/LivesData
@onready var timer_data: Label = $PanelContainer/Rows/Row1/TimeHBox/TimeData
@onready var score_data: Label = $PanelContainer/Rows/Row1/ScoreHBox/ScoreData
@onready var prompt_data: RichTextLabel = $PanelContainer/Rows/Row2/PromptData
@onready var lives_hint: RichTextLabel = $LivesHint
@onready var hint_theme: Resource = preload("res://Simon/Assets/hint_theme.tres")
var score_hints: Array[Label] = []


# Called every render frame
func _process(_delta: float) -> void:
	if owner.is_game_running:
		# Move Score hints
		var scorehints: Array[Node] = get_tree().get_nodes_in_group("score_hints")
		if scorehints:
			for hint: Label in scorehints:
				if hint.position.y <= score_data.global_position.y + score_data.size.y / 2:
					score_hints.pop_at(score_hints.find(hint))
					hint.queue_free()
					score_data.add_theme_color_override("font_color", Color("#00FF00"))
					update_score(int(score_data.text) + int(hint.text))
					score_color_timer.start(0.1)
				elif hint.position.y <= score_data.global_position.y + 28:
					var dir: Vector2 = score_data.global_position - hint.position
					hint.position += dir.normalized() * 0.75
				else:
					hint.position += Vector2(0, -0.75)
		
		# Move Lives hints
		if lives_hint.visible == true:
			lives_hint.position += Vector2(0.25, -0.5)
		
		# Update the game's current timer
		if !owner.GameClock.is_stopped():
			update_timer()


# Called to update lives counter display
func update_lives(i: int) -> void:
	lives_data.text = str(i)


# Called to update the score counter display
func update_score(i: int) -> void:
	score_data.text = str(i)


# Called to update the timer display
func update_timer() -> void:
	if owner.GameClock.time_left:
		timer_data.text = str(owner.GameClock.time_left).pad_decimals(2)


# Set the time_data to the Game's recital time
func set_time_data() -> void:
	if owner.recital_time:
		timer_data.text = str(owner.recital_time).pad_decimals(2)


# Called to update the prompt
func update_prompt(txt: String) -> void:
	prompt_data.text = txt


# Turn on the +/- Lives Hint
func lives_hint_show(i: int) -> void:
	if i >= 1:
		lives_hint.position = lives_data.global_position - Vector2(14, -28)
		lives_hint.text = "[color=green]+" + str(i) + "[/color]"
	if i < 0:
		lives_hint.position = Vector2(92, 10)
		lives_hint.text = "[color=red]-" + str(abs(i)) + "[/color]"
	lives_hint.visible = true
	lives_hint_timer.start(0.75)


# Turn on the Score Hint
func add_lives_hint(i: int) -> void:
	var hint: Label = Label.new()
	hint.theme = hint_theme
	if i >= 1:
		hint.position = lives_data.global_position + Vector2(-14, 28)
		hint.text = str(i)
		hint.add_to_group("life_gain_hints")
	if i < 0:
		hint.position = lives_data.global_position + Vector2(14, 0)
		hint.text = str(abs(i))
		hint.add_theme_color_override("font_color", Color("#FF0000"))
		hint.add_to_group("life_loss_hints")
	add_child(hint)
	get_tree().create_timer(0.75, false).connect("timeout", func() -> void: hint.queue_free())


func add_score_hint(i: int) -> void:
	var hint: Label = Label.new()
	hint.theme = hint_theme
	hint.autowrap_mode = TextServer.AUTOWRAP_OFF
	hint.text = "+" + str(i)
	hint.position = Vector2(size.x - (str(i).length() * 7 + 7) - 10, score_data.global_position.y + 28)
	if score_hints:
		hint.position.y = score_hints[score_hints.size() - 1].position.y + 20
	score_hints.push_back(hint)
	add_child(hint)
	hint.add_to_group("score_hints")


# Flash the GameHUD TimerData
func flash_time_data() -> void:
	timer_data.add_theme_color_override("font_color", Color("#00FF00"))
	await get_tree().create_timer(0.05).timeout
	timer_data.remove_theme_color_override("font_color")


# Turn off the +/- Lives Hint
func _on_lives_hint_timer_timeout() -> void:
	lives_hint.visible = false


func _on_score_color_timer_timeout() -> void:
	score_data.remove_theme_color_override("font_color")
