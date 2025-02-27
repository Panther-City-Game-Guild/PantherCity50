extends Area2D

var start_position: Vector2 = Vector2.ZERO
var shape: RectangleShape2D = null
var collider: CollisionShape2D = null
var image: ColorRect = null


func init_(position_: Vector2, extents: Vector2, color: Color) -> void:
	position = position_
	start_position = position_
	shape = RectangleShape2D.new()
	shape.extents = extents
	
	collider = CollisionShape2D.new()
	collider.shape = shape
	
	image = ColorRect.new()
	image.color = color
	image.size = shape.extents * 2
	image.position = -shape.extents
	
	self.add_child(collider)
	self.add_child(image)
	self.add_to_group("walls")
