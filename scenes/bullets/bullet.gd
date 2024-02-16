extends Area2D
class_name Bullet

@export var damage: int = 1
@export var speed: int = 750
@export var destroy_on_hit := true
@export var shader_material : ShaderMaterial = null

var velocity: Vector2 = Vector2.ZERO
var _started = false

func _ready():
	pass

func _process(delta):
	if $Bullet.material != shader_material:
		$Bullet.material = shader_material
	position += velocity * delta

func start(start_pos: Vector2, target_pos: Vector2):
	var dir = (target_pos - start_pos).angle()
	rotation = dir
	global_position = start_pos
	velocity = Vector2(speed, 0).rotated(rotation)
	_started = true
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	if _started:
		queue_free()
	
func _to_string():
	return "<Bullet position="+str(position)+" velocity="+str(velocity)+" rotation="+str(rotation)+">"

func _on_area_entered(area):
	if !_started:
		return
		
	var hit_something = false
	if area.has_method("damage"):
		hit_something = area.damage(damage)
		
	if destroy_on_hit && hit_something:
		queue_free()

