extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_exit_tile_player_exits(LevelToGoTo: String) -> void:
	SceneManager.call_deferred("GoToNewSceneString",self, Globals.Game_Globals[LevelToGoTo])


func _on_steak_manager_all_steak_collected() -> void:
	$ExitTile.ActavateExit()
