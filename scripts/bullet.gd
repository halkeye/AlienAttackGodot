extends Area2D
class_name Bullet

@export var damage: int = 1
@export var speed: int = 750

var velocity: Vector2 = Vector2.ZERO

func _ready():
	pass

func _process(delta):
	position += velocity * delta

func start(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _to_string():
	return "<CharacterBody2D position="+str(position)+" velocity="+str(velocity)+" rotation="+str(rotation)+">"

func _on_area_entered(area):
	var hit_something = false
	if area is UFO:
		var ufo: UFO = area
		if !ufo.is_dead():
			hit_something = true
			ufo.damage(damage)
	if area is City:
		var city: City = area
		hit_something = true
		city.damage(damage)	
		
	if hit_something:
		queue_free()

