extends AnimatedSprite2D

# If you have multiple switches, use this to identify the switch
@export var ButtonName: String = "Button"

# Track the state of the switch: 0 = off, 1 = on
enum ButtonState {
	off,
	on
}

# Array to store handles to controlled children in
var ControlledChildren: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = ButtonState.off
	for child in self.get_children():
		if child != $ButtonArea:
			ControlledChildren.append(child)

# Body entered the Button's Area
func _on_area_2d_body_entered(_body: Node2D) -> void:
		toggle_children(ButtonState.on)

# Body exited the Button's Area
func _on_area_2d_body_exited(_body: Node2D) -> void:
		toggle_children(ButtonState.off)

# for areas like box enter
func _on_button_area_area_entered(_area: Area2D) -> void:
	toggle_children(ButtonState.on)

# for areas like box exit
func _on_button_area_area_exited(_area: Area2D) -> void:
	toggle_children(ButtonState.off)

func toggle_children(state: ButtonState) -> void:
	frame = state
	if ControlledChildren:
		for Child: Node in ControlledChildren:
			Child.SetState(state)
