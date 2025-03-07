extends Area2D

const ACCELERATION := 400.0  # pixels/sec^2
const MAX_VELOCITY := 225.0  # pixels/sec
const KEYMAP := {
	"left": [KEY_J, KEY_A, KEY_LEFT],
	"right": [KEY_K, KEY_D, KEY_RIGHT],
}

var thrusting_left := false
var thrusting_right := false
var velocity := 0.0
var start_position := Vector2.ZERO
var dead := false

@onready var exhaust_left: Polygon2D = $ExhaustLeft
@onready var exhaust_right: Polygon2D = $ExhaustRight
@onready var collider := $Collider
@onready var ship_shape := $ShipShape
@onready var thrust_sound: AudioStreamPlayer = $ThrustSound
@onready var crash_sound: AudioStreamPlayer = $CrashSound


func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))


func reset() -> void:
	position = start_position
	dead = false
	velocity = 0.0
	thrusting_left = false
	thrusting_right = false


func _on_area_entered(area: Area2D) -> void:
	# Check if the collided area belongs to the group 'wall'
	if not dead and area.is_in_group("walls"):
		dead = true
		thrusting_left = false
		thrusting_right = false
		thrust_sound.stop()
		crash_sound.play()
		get_parent().ship_crashed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	visible = not dead
	if dead:
		return
	var delta_v := ACCELERATION * _delta
	if thrusting_left:
		velocity -= delta_v
	if thrusting_right:
		velocity += delta_v
	velocity = clamp(velocity, -MAX_VELOCITY, MAX_VELOCITY)
	position += Vector2(velocity * _delta, 0)

	# Play thrust sound while ship is thrusting
	if thrusting_left or thrusting_right:
		if not thrust_sound.playing:
			thrust_sound.play()
	else:
		if thrust_sound.playing:
			thrust_sound.stop()


func _input(_event: InputEvent) -> void:
	thrusting_left = false
	for key: Key in KEYMAP["left"]:
		if Input.is_key_pressed(key):
			thrusting_left = true

	thrusting_right = false
	for key: Key in KEYMAP["right"]:
		if Input.is_key_pressed(key):
			thrusting_right = true

	exhaust_left.visible = thrusting_right
	exhaust_right.visible = thrusting_left
