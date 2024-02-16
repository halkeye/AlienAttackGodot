extends Node2D
class_name BulletWideArea

@onready var bullet = $bullet

var _target_pos: Vector2 = Vector2.ZERO
		
func start(start_pos: Vector2, target_pos: Vector2):
	_target_pos = target_pos
	$bullet.start(start_pos, target_pos)
	
func _to_string():
	return "<BulletWideArea position="+str($bullet.position)+" velocity="+str($bullet.velocity)+" rotation="+str($bullet.rotation)+">"

func _process(delta):
	if !$bullet:
		return
		
	if _target_pos != Vector2.ZERO:
		var diff = (_target_pos - $bullet.global_position).abs()
		var average_diff = (diff.x + diff.y) / 2.0
		## FIXME - collision should be disabled until expanding?
		# if it has less than one tick to go
		if average_diff <= delta*$bullet.speed:
			$bullet.velocity = Vector2.ZERO
			$AnimationPlayer.play("grow")

func _on_child_exiting_tree(node):
	if node == bullet:
		queue_free()
