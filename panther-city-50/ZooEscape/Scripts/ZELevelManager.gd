extends Node2D

# this is the code to go to this level
@export var LevelCode := "0000"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_exit_tile_player_exits(LevelToGoTo: PackedScene) -> void:
	SceneManager.call_deferred("GoToNewScenePacked",self, LevelToGoTo)


func _on_steak_manager_all_steak_collected() -> void:
	$ExitTile.ActavateExit()
