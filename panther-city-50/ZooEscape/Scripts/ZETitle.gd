extends Node2D

@onready var newGamePos := Vector2(272, 244)
@onready var passwordPos := Vector2(272, 272)
@onready var selector := $Selector

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selector.position = newGamePos
	setLevelGlobals()


# Called when an InputEvent is detected
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#TODO: this will be go to setting manager at some point
		Globals.Game_Globals.clear()
		SceneManager.GoToNewSceneString(self, Scenes.GameSelection)
		
	if Input.is_action_just_pressed("ui_accept"):
		if selector.position == newGamePos:
			SceneManager.GoToNewSceneString(self, Scenes.ZEDebug)
		elif selector.position == passwordPos:
			pass # will make a password scean at some point
			
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		swapSelectorPos()


func swapSelectorPos() -> void:
	if selector.position == newGamePos:
		selector.position = passwordPos
	else: 
		selector.position = newGamePos

func setLevelGlobals() -> void:
	# debug levels
	Globals.Game_Globals["TL01"] = Scenes.ZETitle
	Globals.Game_Globals["DL01"] = Scenes.ZEDebug
	Globals.Game_Globals["DL02"] = Scenes.ZEDebug2
	
	# Real Levels
	Globals.Game_Globals["0001"] = Scenes.ZETutorial1
	
	# Globals.Game_Globals["0387"] = 
	# Globals.Game_Globals["9102"] = 
	# Globals.Game_Globals["1476"] = 
	# Globals.Game_Globals["5829"] = 
	# Globals.Game_Globals["0053"] = 
	
	# Globals.Game_Globals["7618"] = 
	# Globals.Game_Globals["2940"] = 
	# Globals.Game_Globals["8365"] = 
	# Globals.Game_Globals["0721"] = 
	# Globals.Game_Globals["6594"] = 
	
	# Globals.Game_Globals["3082"] = 
	# Globals.Game_Globals["9817"] = 
	# Globals.Game_Globals["4250"] = 
	# Globals.Game_Globals["1639"] = 
	# Globals.Game_Globals["7048"] = 
	
	# Globals.Game_Globals["2561"] = 
	# Globals.Game_Globals["8934"] = 
	# Globals.Game_Globals["0195"] = 
	# Globals.Game_Globals["5473"] = 
	# Globals.Game_Globals["3706"] = 
