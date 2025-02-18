extends Node2D

# If you have multiple switches, use this to identify the switch
@export var SwitchName: String = "Switch"

# Track the state of the switch: 0 = off, 1 = on
@export var SwitchState: int = 0


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


# Called to change the state of this switch
func set_switch_state(state: int = 0):
		SwitchState = state
		self.frame = SwitchState
		Globals.set_switched_state.emit(SwitchName, SwitchState)
		print(SwitchName, " toggled.  New state: ", SwitchState)


# Called to retrieve the state of this switch
func get_switch_state():
	return SwitchState
