class_name ZELevelManager extends Node2D

@export var LevelCode: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_R:
		restartRoom()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_exit_tile_player_exits(LevelToGoTo: String) -> void:
	SceneManager.call_deferred("GoToNewSceneString",self, Globals.Game_Globals[LevelToGoTo])

func _on_steak_manager_all_steak_collected() -> void:
	$ExitTile.ActavateExit()

func restartRoom() -> void:
	SceneManager.call_deferred("GoToNewSceneString",self, Globals.Game_Globals[LevelCode])

func _on_player_in_water() -> void:
	restartRoom()
