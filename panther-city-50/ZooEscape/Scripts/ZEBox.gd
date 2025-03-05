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

func _on_water_check_area_entered(area: Area2D) -> void:
		area.queue_free()
		
		currentState = states.InWater
	
		# TODO: set to water frame
		
		# removes the collision of the box
		collision_layer = 0
