extends Node2D

@export var sub_forkyfy : bool = false

var lighting_scene : PackedScene = preload("res://scenes/components/lightning.tscn")

func _process(delta):
	if Input.is_action_just_pressed("fire"):
		var fork_count = 1
		var sub_fork_count = 1

		var forks_array: Array = []
		var sub_fork_length: float = 0

		var mouse_position: Vector2
		var from_to: Vector2
		var normal: Vector2
		var fork_offset: float = 300
		var target: Vector2
		var length_offset : float = 1

		mouse_position = get_global_mouse_position()
		forks_array.clear()
		for fork in range(0, fork_count):
			var lightning_instance : Lightning = lighting_scene.instantiate()
			if fork == 0:
				target = mouse_position
			else:
				length_offset = randf()
				target = (mouse_position + normal * randf_range(-fork_offset, fork_offset)) * length_offset
			from_to = target - global_position
			if sub_forkyfy:
				sub_fork_count = from_to.length() / 40
				sub_fork_length = from_to.length() / 5
			normal = Vector2(from_to.y, -from_to.x).normalized()
			add_child(lightning_instance)
			lightning_instance.set_start(global_position)
			lightning_instance.set_end(target)
			lightning_instance.segmentize(from_to, global_position)
			lightning_instance.swayize(normal)
			await get_tree().process_frame 
			lightning_instance.anim_player.play("Fade")
			forks_array.append(lightning_instance)
			if sub_fork_count > 0:
				for sub_fork in range(0, sub_fork_count):
					var picked_fork : Lightning = forks_array[randi_range(0, forks_array.size()-1)]
					sub_forkify(from_to, normal, target, sub_fork_length, picked_fork.get_point_position(randf_range(0, picked_fork.get_point_count() - 1)))

func sub_forkify(from_to: Vector2, normal: Vector2,target: Vector2, sub_fork_length: float, point: Vector2) -> void:
	var lightning_instance : Lightning = lighting_scene.instantiate()
	var sub_target : Vector2 = (point + normal * randf_range(-sub_fork_length, sub_fork_length)) + (target/4) * randf()
	var sub_from_to = sub_target - point
	var sub_normal : Vector2 = Vector2(sub_from_to.y, -sub_from_to.x).normalized()
	add_child(lightning_instance)
	lightning_instance.set_start(point)
	lightning_instance.set_end(sub_target)
	lightning_instance.segmentize(sub_from_to, point)
	lightning_instance.swayize(sub_normal)
	await get_tree().process_frame 
	lightning_instance.anim_player.play("Fade")
