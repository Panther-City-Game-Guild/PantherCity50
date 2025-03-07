class_name GameRoot extends Node2D

func _ready() -> void:
	SceneManager.gameRoot = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_settings_manager"):
		$SettingsManager.visible = !$SettingsManager.visible

func GoToNextScene(OldScene: Node, NewScene: PackedScene) -> void:
	# TODO: Add a transition
	typeof(OldScene)
	add_child(NewScene.instantiate())
	
	OldScene.queue_free()
