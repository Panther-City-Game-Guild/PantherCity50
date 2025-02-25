extends Area2D


var thrusting_left := false
var thrusting_right := false
var velocity := 0.0
const ACCELERATION := 400.0	# pixels/sec^2
const MAX_VELOCITY := 225.0	# pixels/sec

@onready var exhaust_left: Polygon2D = $ExhaustLeft
@onready var exhaust_right: Polygon2D = $ExhaustRight
@onready var collider := $Collider
@onready var ship_shape := $ShipShape

	
func _ready() -> void:
	# Connect the signal from the Area2D node (the ship) to check for entering another area.
	connect("area_entered", Callable(self, "_on_area_entered"))
	print("Here we go!")
	
	
func _on_area_entered(area: Area2D) -> void:
	# Check if the collided area belongs to the group 'wall'
	if area.is_in_group("walls"):
		print("Ship collided with wall!")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var delta_v := ACCELERATION * _delta
	if thrusting_left:
		velocity -= delta_v
	if thrusting_right:
		velocity += delta_v
	velocity = clamp(velocity, -MAX_VELOCITY, MAX_VELOCITY)
	position += Vector2(velocity * _delta, 0)

	
func _input(_event: InputEvent) -> void:
	thrusting_left = Input.is_key_pressed(KEY_J)
	thrusting_right = Input.is_key_pressed(KEY_K)
		
	exhaust_left.visible = thrusting_right
	exhaust_right.visible = thrusting_left
