extends Node

const FRAGMENT_LENGTH := 20.0
const BUMP_HEIGHT := 5.0
const MAX_SHIFT := 200.0
const MIN_CHUNK_LENGTH := 50.0
const MAX_CHUNK_LENGTH := 200.0
const MIN_CAVE_X := 20.0
const MAX_CAVE_X := 640.0 - MIN_CAVE_X
const MIN_ABS_SLOPE := 0.3

var distance := 0.0
var cave_chunks_left: Array[Area2D] = []
var cave_chunks_right: Array[Area2D] = []
var cave_center := 0.0
var cave_width := 0.0
var cave_slope := 0.0
var max_slope_change := 1.0


func _ready() -> void:
	reset()


func reset() -> void:
	distance = 0
	cave_center = 160
	cave_width = _cave_width()
	for chunk in cave_chunks_left:
		remove_child(chunk)
	for chunk in cave_chunks_right:
		remove_child(chunk)
	cave_chunks_left = []
	cave_chunks_right = []
	# Create the starter chunks
	_create_next_chunks()


func move(by_distance: float) -> void:
	self.distance += by_distance
	for chunk in cave_chunks_left:
		chunk.position += Vector2(0, by_distance)
	for chunk in cave_chunks_right:
		chunk.position += Vector2(0, by_distance)

	# Create new chunks when we need to
	if cave_chunks_left.front().position.y > -100:
		_create_next_chunks()

	# Delete cave chunks when they have fallen off bottom of the screen
	var last_chunk: Area2D = cave_chunks_left.back()
	if last_chunk.get_meta("height") + last_chunk.position.y > get_parent().SCREEN_HEIGHT + 100:
		remove_child(cave_chunks_left.pop_back())
		remove_child(cave_chunks_right.pop_back())


func _create_next_chunks() -> void:
	var next_cave_center: float
	var start_y: float
	var end_y: float
	var next_chunk_length: float

	var next_cave_width := _cave_width() * randf_range(1, 1.2)
	if cave_chunks_left.size() == 0:
		next_cave_center = 320.0
		cave_center = 320.0
		cave_slope = 0.0
		cave_width = 300
		next_chunk_length = MIN_CHUNK_LENGTH
		start_y = 0
	else:
		next_chunk_length = randf_range(MIN_CHUNK_LENGTH, MAX_CHUNK_LENGTH)
		if cave_chunks_left.size() < 5:
			next_chunk_length = MIN_CHUNK_LENGTH

		var min_next_slope: float = max(
			(MIN_CAVE_X - cave_center + next_cave_width) / next_chunk_length,
			cave_slope - max_slope_change
		)
		var max_next_slope: float = min(
			(MAX_CAVE_X - cave_center - next_cave_width) / next_chunk_length,
			cave_slope + max_slope_change
		)
		cave_slope = randf_range(min_next_slope, max_next_slope)
		if abs(cave_slope) < MIN_ABS_SLOPE:
			cave_slope = sign(cave_slope) * MIN_ABS_SLOPE
		next_cave_center = cave_center + cave_slope * next_chunk_length
		start_y = cave_chunks_left.front().get_meta("height") + cave_chunks_left.front().position.y
		print(cave_slope)

	end_y = start_y - next_chunk_length

	# TODO: Lots of code duplicated here, refactor it!
	# Create the left chunk
	var left_wall_start := Vector2(cave_center - cave_width / 2, start_y)
	var left_wall_end := Vector2(next_cave_center - next_cave_width / 2, end_y)
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
	left_chunk.set_meta("height", edge_end.y)
	left_chunk.add_to_group("walls")
	cave_chunks_left.insert(0, left_chunk)
	add_child(left_chunk)

	# Create the right chunk
	var right_wall_start := Vector2(cave_center + cave_width / 2, start_y)
	var right_wall_end := Vector2(next_cave_center + next_cave_width / 2, end_y)
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
	right_chunk.set_meta("height", edge_end.y)
	right_chunk.add_to_group("walls")
	cave_chunks_right.insert(0, right_chunk)
	add_child(right_chunk)

	cave_center = next_cave_center
	cave_width = next_cave_width


func _cave_width() -> float:
	# The approximate width of the cave at the current distance. Decreases linearly from
	# the initial width at distance zero, to the minimum at distance max_distance.
	const INITIAL_WIDTH := 190.0
	const MIN_WIDTH    := 100.0
	const MAX_DISTANCE := 60_000
	return INITIAL_WIDTH - (INITIAL_WIDTH - MIN_WIDTH) * (distance / MAX_DISTANCE)


func _rough_edge(
	start: Vector2,
	end: Vector2,
) -> Array[Vector2]:
	# Returns a list of points that form a jagged line between start and end.
	var length := start.distance_to(end)
	var angle := (end - start).angle()
	var num_segments := int(length / FRAGMENT_LENGTH)
	var segment_length := length / num_segments

	var points: Array[Vector2] = [start]
	for i in range(1, num_segments - 1):
		var x := i * segment_length + randf_range(-segment_length / 3, segment_length / 3)
		var y := randf_range(-BUMP_HEIGHT, BUMP_HEIGHT)
		points.append(Vector2(x, y) + start)

	var rotated: Array[Vector2] = _rotate_points(points, start, angle)
	rotated[0] = start
	rotated.append(end)
	return rotated


func _rotate_points(points: Array[Vector2], center: Vector2, angle: float) -> Array[Vector2]:
	var rotated_points: Array[Vector2] = []
	for point in points:
		var rotated: Vector2 = center + (point - center).rotated(angle)
		rotated_points.append(rotated)
	return rotated_points
