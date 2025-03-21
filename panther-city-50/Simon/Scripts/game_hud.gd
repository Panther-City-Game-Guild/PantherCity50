extends Control

@onready var lives_hint: RichTextLabel = $LivesHint
@onready var score_hint: RichTextLabel = $ScoreHint
var hint_theme: Resource = preload("res://Simon/Assets/hint_theme.tres")


# Called every render frame
func _process(_delta: float) -> void:
	if owner.is_game_running:
		# Move Score hints
		var hints: Array[Node] = get_tree().get_nodes_in_group("score_hints")
		if hints:
			for hint in hints:
				hint.position += Vector2(0.25, -0.5)
		
		# Move Lives hints
		if lives_hint.visible == true:
			lives_hint.position += Vector2(0.25, -0.5)
		
		# Update the game's current timer
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

# Turn on the +/- Lives Hint
func lives_hint_show(i: int) -> void:
	if i >= 1:
		lives_hint.position = $PanelContainer/Rows/Row1/LivesHBox/LivesData.global_position - Vector2(14, -28)
		lives_hint.text = "[color=green]+" + str(i) + "[/color]"
	if i < 0:
		lives_hint.position = Vector2(92, 10)
		lives_hint.text = "[color=red]-" + str(abs(i)) + "[/color]"
	lives_hint.visible = true
	$LivesHintTimer.start(0.75)

# Turn on the Score Hint
func add_lives_hint(i: int) -> void:
	var hint: Label = Label.new()
	if i >= 1:
		hint.theme = hint_theme
		hint.position = $PanelContainer/Rows/Row1/LivesHBox/LivesData.global_position - Vector2(14, -28)
		hint.text = str(i)
	if i < 0:
		hint.position = Vector2(92, 10)
		hint.text = str(abs(i))
		hint.add_theme_color_override("font_color", Color("#FF0000"))
	add_child(hint)
	get_tree().create_timer(0.75, false).connect("timeout", func() -> void: hint.queue_free())


func add_score_hint(i: int) -> void:
	var hint: Label = Label.new()
	hint.theme = hint_theme
	hint.position = $PanelContainer/Rows/Row1/ScoreHBox/ScoreData.global_position - Vector2(14, -28)
	hint.autowrap_mode = TextServer.AUTOWRAP_OFF
	hint.text = str(i)
	add_child(hint)
	hint.add_to_group("score_hints")
	get_tree().create_timer(0.75, false).connect("timeout", func() -> void: hint.queue_free())

# Turn off the +/- Lives Hint
func _on_lives_hint_timer_timeout() -> void:
	lives_hint.visible = false


func _on_score_hint_timer_timeout() -> void:
	score_hint.visible = false
