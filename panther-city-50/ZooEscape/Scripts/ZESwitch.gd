extends Node2D

# If you have multiple switches, use this to identify the switch
@export var SwitchName: String = "Switch"

# Track the state of the switch: 0 = off, 1 = on
@onready var SwitchState: int = 0

 # An array of Raycasts in NESW / (Top/Right/Bottom/Left) / (Up/Right/Down/Left) order
@onready var RayCasts = [ $Area2D/RayCast2D_1, $Area2D/RayCast2D_2, $Area2D/RayCast2D_3, $Area2D/RayCast2D_4, ]


### Signal ###
# Use Globals.set_switched_state.emit(switchName, switchState) to tell connected "children" to turn on or off
# In "child" nodes, use Globals.set_switched_state.connect() inside the _ready() function
# signal set_switched_state(switchName, switchState)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# TODO: Detect FACING
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ActionButton"):
		var collider: CharacterBody2D
		for r in RayCasts:
			if r.is_colliding():
				collider = r.get_collider()
	
		if collider && collider.name == "Player":
			SwitchState = !SwitchState
			self.frame = SwitchState
			Globals.set_switched_state.emit(SwitchName, SwitchState)
