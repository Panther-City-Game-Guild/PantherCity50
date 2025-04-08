extends Node2D

enum state {
	closed,
	open
}

@onready var currentState: int = state.closed

func _ready() -> void:
	$Sprite2D.frame = currentState

func SetState(newState: int) -> void:
	currentState = newState
	
	if currentState == state.open:
		$Area2D.collision_layer = 0
	else:
		$Area2D.collision_layer = 1
	
	$Sprite2D.frame = currentState
