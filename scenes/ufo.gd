extends CharacterBody2D
class_name UFO

@export_group("Health")
@export var health: int = 1 : set=set_health
@export var max_health:int = 1

@onready var image = preload("res://sprites/UFO.png")
@onready var dead_image = preload("res://sprites/UFOBoom.png")

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
	if (health <= 0):
		$Sprite.set_texture(dead_image)
	else:
		$Sprite.set_texture(image)
	
func damage(amount: int = 1):
	health -= amount

func _process(delta):
	pass

func _on_visible_on_screen_notifier_2d_screen_exited():
	speed = -1 * speed 
	velocity = Vector2(speed, 0)

func reverse():
	speed = -1 * speed 
	velocity = Vector2(speed, 0)
