extends Node

signal new_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)
		
	if Input.is_action_just_pressed("ui_accept"):
		SceneManager.GoToNewSceneString(self, Scenes.SimonTitle)
