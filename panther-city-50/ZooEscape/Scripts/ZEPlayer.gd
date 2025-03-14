extends CharacterBody2D

enum PlayerState {
	Idle,
	InWater,
	OnExit
}

@onready var currentDir: Vector2 = Vector2.DOWN
@onready var sprite := $AnimatedSprite2D
@onready var ray := $RayCast2D
@onready var currentState: PlayerState = PlayerState.Idle

signal InWater

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if currentState == PlayerState.Idle:
		if event.is_action_pressed("DigitalUp"):
			MovePlayer(Vector2.UP, "IdleUp")
		elif event.is_action_pressed("DigitalRight"):
			MovePlayer(Vector2.RIGHT, "IdleRight")
		elif event.is_action_pressed("DigitalDown"):
			MovePlayer(Vector2.DOWN, "IdleDown")
		elif event.is_action_pressed("DigitalLeft"):
			MovePlayer(Vector2.LEFT, "IdleLeft")
		
		if event.is_action_pressed("ActionButton"):
			# Detect if "ray" is colliding with an object
			# - If so, try to interact
			if ray.is_colliding():
				InteractWithRayCollider(ray.get_collider())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Called to move the player
func MovePlayer(dir: Vector2, animation: String) -> void:
	sprite.play(animation)
	ray.target_position = dir * Globals.ZETileSize
	ray.force_raycast_update()
	
	if ray.is_colliding():
		var collidingObj: Object = ray.get_collider()
		if collidingObj is ZEBoxArea:
			if collidingObj.Move(dir):
				position += dir * Globals.ZETileSize
	elif !ray.is_colliding():
		position += dir * Globals.ZETileSize

# Called to attempt interaction with various objects when player is facing a collider
func InteractWithRayCollider(obj: Object) -> void:
	# Is colliding object interactable?
	# - This expects a collision body as a child of a different node, like a Sprite2D, CharacterBody2D, or Area2D
	# - See the ZESwitch.tscn file for scene tree example	
	if obj.is_in_group("ZEInteractable"):
		if obj is ZESwitch:
			obj.ChangeState()

func _on_water_check_area_entered(_area: Area2D) -> void:
	# TODO: play drown animaiton
	currentState = PlayerState.InWater
	
	# tell the level to restart
	InWater.emit()
