class_name GameRoot extends Node2D

func _ready() -> void:
	SceneManager.gameRoot = self

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_settings_manager"):
		if $SettingsManager.visible:
			$SettingsManager.visible = false
		else:
			$SettingsManager.visible = true

func GoToNextScene(OldScene, NewScene: PackedScene) -> void:
	# TODO: Add a transition
	remove_child(OldScene)
	add_child(NewScene.instantiate())
