extends Node

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_settings_manager"):
		if $SettingsManager.visible:
			$SettingsManager.visible = false
		else:
			$SettingsManager.visible = true
