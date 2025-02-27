extends Node2D

const SCREEN_WIDTH: int = 640
const SCREEN_HEIGHT: int = 360

const DESCENT_SPEED: int = 150
const NUM_WALLS: int = 20
const WALL_WIDTH: int = 200
const WALL_HEIGHT: int = 25

@onready var ship_scene: PackedScene = load("res://Drifter/Scenes/Ship.tscn")
@onready var cave_script: GDScript = load("res://Drifter/Scripts/cave.gd")

@onready var ship: Area2D = null
@onready var walls: Array[Area2D] = []
@onready var cave: Node = null


func _ready() -> void:
	# Instantiate the ship
	ship = ship_scene.instantiate()
	ship.position = Vector2(320, 280)
	ship.start_position = ship.position
	self.add_child(ship)
	
	# Instantiate the cave
	cave = cave_script.new()
	self.add_child(cave)
	
		
func ship_crashed() -> void:
	print("Ship crashed!")
	ship.position = Vector2(32000, 280)
	await get_tree().create_timer(1.0).timeout
	reset()
		
		
func reset() -> void:
	cave.reset()
	ship.reset()
	
	
func _process(delta: float) -> void:
	cave.move(DESCENT_SPEED * delta)


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		SceneManager.GoToNewSceneString(self, "res://Drifter/Scenes/TitleScreen.tscn")
