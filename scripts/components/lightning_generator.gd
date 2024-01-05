extends Node2D
class_name LightingGenerator

signal lightning_done

var lighting_segment_scene : PackedScene = preload("res://scenes/components/lightning_segment.tscn")

var segment_count = 0

func generate(container: Node2D, start_pos: Vector2, end_pos: Vector2) -> void:
	var fork_count = 1

	var from_to: Vector2
	var normal: Vector2
	var fork_offset: float = 300
	var target: Vector2
	var length_offset : float = 1

	for fork in range(0, fork_count):
		var lighting_segment_instance : LightningSegment = lighting_segment_scene.instantiate()
		if fork == 0:
			target = end_pos
		else:
			length_offset = randf()
			target = (start_pos + normal * randf_range(-fork_offset, fork_offset)) * length_offset
		from_to = target - start_pos
		normal = Vector2(from_to.y, -from_to.x).normalized()
		container.add_child(lighting_segment_instance)
		segment_count += 1
		lighting_segment_instance.lightning_done.connect(done)
		lighting_segment_instance.set_start(start_pos)
		lighting_segment_instance.set_end(target)
		lighting_segment_instance.segmentize(from_to, start_pos)
		lighting_segment_instance.swayize(normal)
		lighting_segment_instance.anim_player.play("Fade")


func done() -> void:
	segment_count -= 1
	if segment_count == 0:
		lightning_done.emit()
	return
