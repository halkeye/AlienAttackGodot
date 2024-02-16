extends Node2D
class_name BulletZapper

func start(start_pos: Vector2, target_pos: Vector2):
	global_position = target_pos
	$LightningGenerator.generate(get_parent(), start_pos, target_pos)
	$LightingSoundPlayer.seek(0.0)
	$LightingSoundPlayer.play()
		
func _to_string():
	return "<BulletFirestorm position="+str($bullet.position)+" velocity="+str($bullet.velocity)+" rotation="+str($bullet.rotation)+">"

func _on_lightning_generator_lightning_done():
	for area in $Area2D.get_overlapping_areas():
		if area is UFO:
			area.damage(1000)
	queue_free()
