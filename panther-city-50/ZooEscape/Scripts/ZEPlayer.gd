extends CharacterBody2D

@onready var currentDir: Vector2 = Vector2.DOWN
@onready var sprite = $AnimatedSprite2D
@onready var ray := $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Move player UP
	if Input.is_action_just_pressed("ui_up"):
		MovePlayer(Vector2.UP, "IdleUp")
		
	# Move player RIGHT
	if Input.is_action_just_pressed("ui_right"):
		MovePlayer(Vector2.RIGHT, "IdleRight")
	
	# Move player DOWN
	if Input.is_action_just_pressed("ui_down"):
		MovePlayer(Vector2.DOWN, "IdleDown")
	
	# Move player LEFT
	if Input.is_action_just_pressed("ui_left"):
		MovePlayer(Vector2.LEFT, "IdleLeft")
	
	# Action button pressed - do a thing!
	if Input.is_action_just_pressed("ActionButton"):
		print("Action!")
	
		# Detect if "ray" is colliding with an object
		# - If so, try to interact
		var ray_collider = DetectRayCollider()
		if ray_collider:
			InteractWithRayCollider(ray_collider)


# Called to move the player
func MovePlayer(dir: Vector2, animation: String) -> void:
	sprite.play(animation)
	ray.target_position = dir * Globals.ZETileSize
	ray.force_raycast_update()
	if !ray.is_colliding():
		position += dir * Globals.ZETileSize


# Called to detect and retrieve anything the "ray" is colliding with
func DetectRayCollider():
	if ray.is_colliding():
		return ray.get_collider()


# Called to attempt interaction with various objects when player is facing a collider
func InteractWithRayCollider(obj):
	# Is colliding object interactable?
	# - This expects a collision body as a child of a different node, like a Sprite2D, CharacterBody2D, or Area2D
	# - See the ZESwitch.tscn file for scene tree example
	if obj.is_in_group("ZEInteractable"):
		var parent = obj.get_parent()
	
		# Is it a switch? If so, switch its state!
		if parent.has_method("get_switch_state") && parent.has_method("set_switch_state"):
			var cState = parent.call("get_switch_state")
			parent.call("set_switch_state", !cState)
