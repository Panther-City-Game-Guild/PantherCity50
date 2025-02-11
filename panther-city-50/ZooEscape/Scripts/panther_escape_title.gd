extends Node2D

@onready var newGamePos := Vector2(272, 244)
@onready var passwordPos := Vector2(272, 272)
@onready var selector = $Selector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selector.position = newGamePos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file(Scenes.GameSelection)
		
	if Input.is_action_just_pressed("ui_accept"):
		if selector.position == newGamePos:
			get_tree().change_scene_to_file(Scenes.ZEDebug)
		elif selector.position == passwordPos:
			pass # will make a password scean at some point
			
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		swapSelectorPos()


func swapSelectorPos() -> void:
	if selector.position == newGamePos:
		selector.position = passwordPos
	else: 
		selector.position = newGamePos
