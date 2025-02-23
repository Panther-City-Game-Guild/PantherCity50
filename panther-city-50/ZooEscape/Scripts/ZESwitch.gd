extends Node2D

# If you have multiple switches, use this to identify the switch
@export var SwitchName: String = "Switch"

# Track the state of the switch: 0 = off, 1 = on
@export var SwitchState: int = 1

# Array to store handles to controlled children in
var ControlledChildren = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.frame = SwitchState
	for child in self.get_children():
		if child != $SwitchArea:
			ControlledChildren.append(child)
	print(SwitchName, "-controlled children:\n  ", ControlledChildren)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Called to change the state of this switch
func set_switch_state(state):
		SwitchState = state
		self.frame = SwitchState
		print(SwitchName, " toggled.  New state: ", SwitchState)
		toggle_children(SwitchState)


func toggle_children(state):
	if ControlledChildren:
			for Child in ControlledChildren:
				# Set some variable / property -- replace below as needed
				print(" Toggling visibility on child nodes: ", state)
				Child.visible = !Child.visible


# Called to retrieve the state of this switch
func get_switch_state():
	return SwitchState


func _on_switch_area_switch_state() -> void:
	set_switch_state(!SwitchState)
