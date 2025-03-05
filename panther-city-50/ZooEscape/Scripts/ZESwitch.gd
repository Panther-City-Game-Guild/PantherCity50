extends AnimatedSprite2D

# If you have multiple switches, use this to identify the switch
@export var SwitchName: String = "Switch"

# Track the state of the switch: 0 = off, 1 = on
@export var SwitchState: int = 1

# Array to store handles to controlled children in
var ControlledChildren: Array = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = SwitchState
	for child in get_children():
		if child != $SwitchArea:
			ControlledChildren.append(child)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Called to change the state of this switch
func set_switch_state(state: int) -> void:
		SwitchState = state
		frame = SwitchState
		toggle_children(SwitchState)


func toggle_children(_state: int) -> void:
	if ControlledChildren:
			for Child: Node in ControlledChildren:
				# Set some variable / property -- replace below as needed
				Child.visible = !Child.visible


# Called to retrieve the state of this switch
func get_switch_state() -> int:
	return SwitchState


func _on_switch_area_switch_state() -> void:
	set_switch_state(!SwitchState)
