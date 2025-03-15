class_name ZELevelManager extends Node2D

@export var LevelCode: String = ""
@onready var player := $Player
@onready var resetTime := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("RightBumper"):
		resetTime += delta
	
	if Input.is_action_just_released("RightBumper"):
		resetTime = 0

	if resetTime > 2:
		resetTime = 0
		restartRoom()

func _on_exit_tile_player_exits(LevelToGoTo: String) -> void:
	player.currentState = player.PlayerState.OnExit
	SceneManager.call_deferred("GoToNewSceneString",self, Globals.Game_Globals[LevelToGoTo])

func _on_steak_manager_all_steak_collected() -> void:
	$ExitTile.ActavateExit()

func restartRoom() -> void:
	SceneManager.call_deferred("GoToNewSceneString",self, Globals.Game_Globals[LevelCode])

func _on_player_in_water() -> void:
	restartRoom()
