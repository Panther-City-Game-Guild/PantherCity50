extends Node2D

const DESCENT_SPEED: int = 100
const NUM_WALLS: int = 20
const WALL_WIDTH: int = 200
const WALL_HEIGHT: int = 25

@onready var ship_scene: PackedScene = load("res://Drifter/Scenes/Ship.tscn")
@onready var wall_script: GDScript = load("res://Drifter/Scripts/wall.gd")

@onready var ship: Area2D = null
@onready var walls: Array[Area2D] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instantiate the ship
	ship = ship_scene.instantiate()
	ship.position = Vector2(320, 280)
	ship.start_position = ship.position
	self.add_child(ship)
	
	# Instantiate the walls
	for i in range(NUM_WALLS):
		var wall: Area2D = wall_script.new()
		var position_:= Vector2(sin(2 * PI * i / NUM_WALLS) * 100, -i * 50)
		var extents := Vector2(WALL_WIDTH, WALL_HEIGHT)
		var color := Color(0.19, 0.277, 0.351)
		wall.init_(position_, extents, color)
		self.add_child(wall)
		walls.append(wall)
		
	for i in range(NUM_WALLS):
		var wall: Area2D = wall_script.new()
		var position_:= Vector2(600 + sin(2 * PI * i / NUM_WALLS) * 100, -i * 50)
		var extents := Vector2(WALL_WIDTH, WALL_HEIGHT)
		var color := Color(0.19, 0.277, 0.351)
		wall.init_(position_, extents, color)
		self.add_child(wall)
		walls.append(wall)
		
		
func ship_crashed() -> void:
	print("Ship crashed!")
	ship.position = Vector2(1000, 1000)
	await get_tree().create_timer(1.0).timeout
	reset()
		
		
func reset() -> void:
	ship.reset()
	for _wall in walls:
		_wall.position = _wall.start_position
	
	
func _process(_delta: float) -> void:
	for _wall in walls:
		_wall.position += Vector2(0, DESCENT_SPEED * _delta)
		if _wall.position.y - WALL_HEIGHT > 360:
			_wall.position += Vector2(0, -WALL_HEIGHT * NUM_WALLS * 2)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneManager.GoToNewSceneString(self, "res://Drifter/Scenes/TitleScreen.tscn")
	if Input.is_key_pressed(KEY_Q):
		get_tree().quit()
