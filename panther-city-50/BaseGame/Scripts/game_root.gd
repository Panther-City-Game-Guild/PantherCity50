class_name GameRoot extends Node2D

@onready var aniPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	SceneManager.gameRoot = self
	aniPlayer.play("RESET")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_settings_manager"):
		$SettingsManager.visible = !$SettingsManager.visible

func GoToNextScene(OldScene: Node, NewScene: PackedScene) -> void:
	# start the Fade out 
	set_process_input(false)
	set_physics_process(false)
	aniPlayer.play("FadeOut")
	await aniPlayer.animation_finished
	
	OldScene.queue_free()
	add_child(NewScene.instantiate())
	
	aniPlayer.play("FadeIn")
	await aniPlayer.animation_finished
	set_process_input(true)
	set_physics_process(true)
