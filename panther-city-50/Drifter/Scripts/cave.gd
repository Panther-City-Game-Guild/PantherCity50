extends Node

var distance := 0.0
var cave_chunks_left: Array[Area2D] = []
var cave_chunks_right: Array[Area2D] = []
var cave_center_x := 0
var cave_width := 0.0

const segment_length := 20
const bump_height := 5
const max_shift := 200
const max_slope := 2.0
const min_chunk_length := 30
const max_chunk_length := 150


func _ready() -> void:
	reset()
	
	
func reset() -> void:
	distance = 0
	cave_center_x = 160
	cave_width = _cave_width()
	for chunk in cave_chunks_left:
		remove_child(chunk)
	for chunk in cave_chunks_right:
		remove_child(chunk)
	cave_chunks_left = []
	cave_chunks_right = []
	# Create the starter chunks
	_create_next_chunks()
	
	
func move(distance_: float) -> void:
	self.distance += distance_
	for chunk in cave_chunks_left:
		chunk.position += Vector2(0, distance_)
	for chunk in cave_chunks_right:
		chunk.position += Vector2(0, distance_)
		
	# Create new chunks when we need to
	if cave_chunks_left.front().position.y > -100:
		_create_next_chunks()

	# Delete cave chunks when they have fallen off bottom of the screen
	var last_chunk: Area2D = cave_chunks_left.back()
	if last_chunk.get_meta("height") + last_chunk.position.y > get_parent().SCREEN_HEIGHT + 100:
		remove_child(cave_chunks_left.pop_back())
		remove_child(cave_chunks_right.pop_back())
	
		
func _create_next_chunks() -> void:
	print("Creating next chunks, currently ", cave_chunks_left.size(), " chunks")
	var next_cave_x: float
	if cave_chunks_left.size() == 0:
		next_cave_x = 320.0
		cave_center_x = 320
		cave_width = 300
	var next_cave_width := _cave_width() * randf_range(1, 2)
	next_cave_x = cave_center_x + randf_range(-max_shift, max_shift)
	next_cave_x = clamp(
		next_cave_x,
		20 + next_cave_width/2,
		get_parent().SCREEN_WIDTH - 20 - next_cave_width/2,
	)
	
	var start_y: float = 0
	var end_y: float = 0
	if cave_chunks_left.size() > 0:
		start_y = cave_chunks_left.front().get_meta("height") + cave_chunks_left.front().position.y
		end_y = start_y - randf_range(min_chunk_length, max_chunk_length)
	else:
		end_y = start_y - max_chunk_length
		
	# TODO: Lots of code duplicated here, refactor it!
	# Create the left chunk
	var left_wall_start := Vector2(cave_center_x - cave_width/2, start_y)
	var left_wall_end := Vector2(next_cave_x - next_cave_width/2, end_y)
	var edge_end := left_wall_end - left_wall_start
	var left_vertices := _rough_edge(Vector2.ZERO, edge_end)
	left_vertices.append(Vector2(-1000, edge_end.y))
	left_vertices.append(Vector2(-1000, 0))
	var left_chunk := Area2D.new()
	left_chunk.position = left_wall_start
	var left_shape := Polygon2D.new()
	left_shape.position = Vector2.ZERO
	left_shape.polygon = left_vertices
	left_shape.color = Color(0.19, 0.277, 0.351)
	var left_collider: CollisionPolygon2D = CollisionPolygon2D.new()
	left_collider.polygon = left_shape.polygon
	left_collider.position = Vector2.ZERO
	left_chunk.add_child(left_collider)
	left_chunk.add_child(left_shape)
	left_chunk.set_meta("height", left_vertices[-2].y)
	left_chunk.add_to_group("walls")
	cave_chunks_left.insert(0, left_chunk)
	add_child(left_chunk)
	
	# Create the right chunk
	var right_wall_start := Vector2(cave_center_x + cave_width/2, start_y)
	var right_wall_end := Vector2(next_cave_x + next_cave_width/2, end_y)
	edge_end = right_wall_end - right_wall_start
	var right_vertices := _rough_edge(Vector2.ZERO, edge_end)
	right_vertices.append(Vector2(1000, edge_end.y))
	right_vertices.append(Vector2(1000, 0))
	var right_chunk := Area2D.new()
	right_chunk.position = right_wall_start
	var right_shape := Polygon2D.new()
	right_shape.position = Vector2.ZERO
	right_shape.polygon = right_vertices
	right_shape.color = Color(0.19, 0.277, 0.351)
	var right_collider: CollisionPolygon2D = CollisionPolygon2D.new()
	right_collider.polygon = right_shape.polygon
	right_collider.position = Vector2.ZERO
	right_chunk.add_child(right_collider)
	right_chunk.add_child(right_shape)
	right_chunk.set_meta("height", right_vertices[-2].y)
	right_chunk.add_to_group("walls")
	cave_chunks_right.insert(0, right_chunk)
	add_child(right_chunk)
	
	cave_center_x = next_cave_x
	cave_width = next_cave_width
	

func _cave_width() -> float:
	# The approximate width of the cave at the current distance. Decreases linearly from
	# the initial width at distance zero, to the minimum at distance max_distance.
	const initial_width := 200.0
	const min_width := 100.0
	const max_distance := 6_000
	return initial_width - (initial_width - min_width) * (distance / max_distance)
	
	
func _rough_edge(
	start: Vector2,
	end: Vector2,
) -> Array[Vector2]:
	# Returns a list of points that form a jagged line between start and end.
	var length := start.distance_to(end)
	var angle := (end - start).angle()
	var num_segments := int(length / segment_length)
	var segment_length_ := length / num_segments

	var points: Array[Vector2] = [start]
	for i in range(1, num_segments - 1):
		var x := i * segment_length_ + randf_range(-segment_length_/3, segment_length_/3)
		var y := randf_range(-bump_height, bump_height)
		points.append(Vector2(x, y) + start)
		
	var rotated: Array[Vector2] = rotate_points(points, start, angle)
	rotated[0] = start
	rotated.append(end)
	return rotated


func rotate_points(points: Array[Vector2], center: Vector2, angle: float) -> Array[Vector2]:
	var rotated_points: Array[Vector2] = []
	for point in points:
		var rotated: Vector2 = center + (point - center).rotated(angle)
		rotated_points.append(rotated)
	return rotated_points
