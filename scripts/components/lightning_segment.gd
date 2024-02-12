extends Line2D
class_name LightningSegment

signal lightning_done

# Borrowed from https://www.youtube.com/watch?v=Hyq7KixGyHY

@onready var anim_player : AnimationPlayer = $AnimationPlayer

@export var divider : float = 10
var points_lerp : Array = []
var sway : float
@export var sway_divider : float = 40

func set_start(at_position: Vector2) -> void:
	add_point(at_position)
	
func set_end(at_position: Vector2) -> void:
	add_point(at_position)
		
func segmentize(from_to: Vector2, start_pos: Vector2) -> void:
	points_lerp.clear()
	var distance : float = from_to.length()
	sway = distance / sway_divider
	sway = clamp(sway, 0, 10)
	var segment_count : int = round(distance / divider)
	for point in range(0, segment_count):
		points_lerp.append(randf())
	points_lerp.sort()
	var point_index : int = 1
	for point_offset in points_lerp:
		add_point(start_pos + point_offset * from_to, point_index)
		point_index += 1

func swayize(normal: Vector2) -> void:
	var point_count : int = get_point_count() - 1
	
	for point in point_count:
		if point == 0 or point == point_count:
			continue
		else:
			var offset = ((get_point_position (point) + get_point_position (point - 1))/2) + normal * randf_range(-sway, sway)
			set_point_position (point, offset)

func done() -> void:
	lightning_done.emit()
	queue_free()
