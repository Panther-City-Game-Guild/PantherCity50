class_name ZEBoxArea extends Area2D

enum states {
	Movable,
	InWater
}

@onready var currentState := states.Movable
@onready var ray := $RayCast2D

func Move(dir: Vector2) -> bool:
	ray.target_position = dir * Globals.ZETileSize
	ray.force_raycast_update()
	
	if currentState == states.Movable && !ray.is_colliding():
		position += dir * Globals.ZETileSize
		return true
	else:
		return false
