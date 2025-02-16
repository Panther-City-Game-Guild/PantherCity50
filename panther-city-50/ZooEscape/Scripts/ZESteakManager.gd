extends Node2D

@onready var SteakTotal := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SteakTotal = get_child_count()
	# remove at some point
	print("Number of steaks: ", SteakTotal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_child_count() == 0:
		# remove at some point
		print("All Steaks collected")
