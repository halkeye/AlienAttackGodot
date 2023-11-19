extends CharacterBody2D
class_name UFO

@export_group("Health")
@export var health: int = 1 : set=set_health
@export var max_health:int = 1

signal health_depleted(ufo: UFO)

const image = preload("res://sprites/UFO.png")
const dead_image = preload("res://sprites/UFOBoom.png")

var speed = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	$Sprite.set_texture(image)
	if randi_range(0, 1) == 0:
		speed = -1 * speed 
		
	velocity = Vector2(speed, 0)
		
func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().has_method("hit"):
			collision.get_collider().hit()
				
func set_health(value : int) -> void:
	health = value
	if (is_dead()):
		$Sprite.set_texture(dead_image)
	else:
		$Sprite.set_texture(image)
	
func damage(amount: int = 1):
	# if no health yet, cant take damage
	if health > 0:
		health -= amount
		if is_dead():
			health_depleted.emit(self)
			

func fire(bullet_scene: PackedScene, pos: Vector2):
	if is_dead():
		return
		
	var bullet = bullet_scene.instantiate()
	var starting_pos = $".".global_position
	bullet.set_collision_mask(1 << 2)
	bullet.start(starting_pos, (pos - starting_pos).angle())
	get_tree().root.add_child(bullet)
	return bullet
	
func _process(delta):
	pass

func is_dead():
	return health <= 0
	
# TODO - rename to wall bounce?
func reverse():
	speed = -1 * speed 
	velocity = Vector2(speed, 0)
	if is_dead():
		queue_free()
