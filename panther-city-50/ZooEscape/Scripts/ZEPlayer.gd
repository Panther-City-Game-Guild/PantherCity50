extends CharacterBody2D

@onready var currentDir: Vector2 = Vector2.DOWN
@onready var sprite = $AnimatedSprite2D
@onready var ray := $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_up"):
		MovePlayer(Vector2.UP, "IdleUp")
		
	if Input.is_action_just_pressed("ui_right"):
		MovePlayer(Vector2.RIGHT, "IdleRight")
		
	if Input.is_action_just_pressed("ui_down"):
		MovePlayer(Vector2.DOWN, "IdleDown")
		
	if Input.is_action_just_pressed("ui_left"):
		MovePlayer(Vector2.LEFT, "IdleLeft")
	
	if  Input.is_action_just_pressed("ActionButton"):
		print("Action")

func MovePlayer(dir: Vector2, animation: String) -> void:
	sprite.play(animation)
	ray.target_position = dir * Globals.ZETileSize
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += dir * Globals.ZETileSize
	
