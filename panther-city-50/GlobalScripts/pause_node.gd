extends Node

signal game_unpaused

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Prevent the root node from being paused
	get_parent().process_mode = Node.PROCESS_MODE_ALWAYS
	
	# This node ONLY processes while the scene tree is paused and acts as a global way to unpause the game
	self.process_mode = Node.PROCESS_MODE_WHEN_PAUSED


# Called when an input event is detected
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause_game"):
		# Set this input as handled so no other nodes process this input when the game unpauses
		# This makes it so nodes listening for pause_game inputs do not repause the game immediately
		get_viewport().set_input_as_handled()
		
		# If the game is paused, unpause it
		if get_tree().paused:
			print(name, ": unpausing game")
			get_tree().paused = false
			
			# Emit signal letting listeners know the game is unpaused
			game_unpaused.emit()
