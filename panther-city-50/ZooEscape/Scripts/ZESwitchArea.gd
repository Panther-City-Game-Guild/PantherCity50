class_name ZESwitch extends Area2D

signal SwitchState

func ChangeState() -> void:
	SwitchState.emit()
