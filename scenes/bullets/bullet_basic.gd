extends Node2D
class_name BulletBasic

@onready var bullet = $bullet

func start(start_pos: Vector2, target_pos: Vector2):
	$bullet.start(start_pos, target_pos)
	$BasicGunSoundPlayer.play()
	
func _to_string():
	return "<BulletBasic position="+str($bullet.position)+" velocity="+str($bullet.velocity)+" rotation="+str($bullet.rotation)+">"

func _on_child_exiting_tree(node):
	if node == bullet:
		queue_free()
