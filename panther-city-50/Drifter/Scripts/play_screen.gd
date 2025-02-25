extends Node2D


const DESCENT_SPEED: int = 100
const NUM_WALLS: int = 20
const WALL_WIDTH: int = 200
const WALL_HEIGHT: int = 25

@onready var dynamic_walls: Array[Area2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(NUM_WALLS):
		var dynamic_wall: Area2D = wall()
		dynamic_wall.position = Vector2(sin(2 * PI * i / NUM_WALLS) * 100, i * 50)
		dynamic_walls.append(dynamic_wall)
		self.add_child(dynamic_wall)
	for i in range(NUM_WALLS):
		var dynamic_wall: Area2D = wall()
		dynamic_wall.position = Vector2(600 + sin(2 * PI * i / NUM_WALLS) * 100, i * 50)
		dynamic_walls.append(dynamic_wall)
		self.add_child(dynamic_wall)
	
	
func _process(_delta: float) -> void:
	for _wall in dynamic_walls:
		_wall.position += Vector2(0, DESCENT_SPEED * _delta)
		if _wall.position.y - WALL_HEIGHT > 360:
			_wall.position += Vector2(0, -WALL_HEIGHT * NUM_WALLS * 2)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneManager.GoToNewSceneString(self, "res://Drifter/Scenes/TitleScreen.tscn")
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()

		
func wall() -> Area2D:
	var _wall: Area2D = Area2D.new()
	
	var wall_shape: RectangleShape2D = RectangleShape2D.new()
	wall_shape.extents = Vector2(WALL_WIDTH, WALL_HEIGHT)
	
	var wall_collider: CollisionShape2D = CollisionShape2D.new()
	wall_collider.shape = wall_shape
	
	var wall_color: ColorRect = ColorRect.new()
	wall_color.color = Color(0.19, 0.277, 0.351)
	wall_color.size = wall_shape.extents * 2
	wall_color.position = -wall_shape.extents
	
	_wall.add_child(wall_collider)
	_wall.add_child(wall_color)
	_wall.add_to_group("walls")
	
	return _wall
