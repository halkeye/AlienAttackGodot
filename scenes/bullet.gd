extends CharacterBody2D
class_name Bullet

@export var damage: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var speed = 750

func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().has_method("damage"):
			collision.get_collider().damage(damage)	
		queue_free()
			
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _to_string():
	return "<CharacterBody2D position="+str(position)+" velocity="+str(velocity)+" rotation="+str(rotation)+">"
