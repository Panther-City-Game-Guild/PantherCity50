extends Node2D

# If you have multiple switches, use this to identify the switch
@export var ButtonName: String = "Button"

# Track the state of the switch: 0 = off, 1 = on
@export var ButtonState: int = 1

# Array to store handles to controlled children in
var ControlledChildren: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.frame = ButtonState
	for child in self.get_children():
		if child != $ButtonArea:
			ControlledChildren.append(child)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# Body entered the Button's Area
func _on_area_2d_body_entered(_body: Node2D) -> void:
		ButtonState = 0
		self.frame = ButtonState
		toggle_children(ButtonState)


# Body exited the Button's Area
func _on_area_2d_body_exited(_body: Node2D) -> void:
		ButtonState = 1
		self.frame = ButtonState
		toggle_children(ButtonState)


func toggle_children(state: int) -> void:
	if ControlledChildren:
			for Child: Node in ControlledChildren:
				# TODO: Set some variable / property -- replace below as needed
				Child.visible = !Child.visible
