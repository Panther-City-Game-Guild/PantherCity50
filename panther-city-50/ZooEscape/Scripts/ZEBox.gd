extends Sprite2D

enum states {
	Movable,
	InWater
}

@onready var currentState := states.Movable
@onready var ray := $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func Move(dir: Vector2):
	ray.target_position = dir * Globals.ZETileSize
	
	if currentState == states.Movable && !ray.is_colliding():
		position += dir * Globals.ZETileSize


func _on_area_2d_try_to_move(dir: Vector2) -> void:
	Move(dir)
