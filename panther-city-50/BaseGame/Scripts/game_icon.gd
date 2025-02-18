extends PanelContainer

@export var GameTitleScene: PackedScene
signal startGame(gameToStart: PackedScene)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed && GameTitleScene != null:
		startGame.emit(GameTitleScene)
