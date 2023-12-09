extends Area2D
class_name UFO

var target_path : PathFollow2D

@export_group("Health")
@export var health: int = 1 : set=set_health
@export var max_health:int = 1

@onready var screensize = get_viewport_rect().size

var bullet_scene = preload("res://scenes/bullet.tscn")

signal health_depleted(ufo: UFO)

var speed = 150
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	if !target_path:
		# for debugging
		target_path = $DebugUFOTargetPath/PathFollow2D
		
	health = max_health
	show_sprite($Ufo)
	if randi_range(0, 1) == 0:
		speed = -1 * speed 
	velocity = Vector2(speed, 0)
		
func start(_position, _direction):
	rotation = _direction
	position = _position
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(_delta):
	pass
			
func _process(delta):
	position.x += delta * speed
	pass
	
func set_health(value : int) -> void:
	health = value
	if (is_dead()):
		show_sprite($Exploded)
	
func damage(amount: int = 1):
	# if no health yet, cant take damage
	if health > 0:
		health -= amount
		if is_dead():
			health_depleted.emit(self)

func fire(bullet_scene: PackedScene, pos: Vector2):
	if is_dead():
		return
		
	var bullet = bullet_scene.instantiate() as Bullet
	var starting_pos = $".".global_position
	bullet.set_collision_mask(1 << 2)
	bullet.start(starting_pos, (pos - starting_pos).angle())
	get_tree().root.add_child(bullet)
	return bullet

func is_dead():
	return health <= 0
	
func reverse():
	speed = -1 * speed 
	velocity = Vector2(speed, 0)
	if is_dead():
		queue_free()

func set_on_fire():
	show_sprite($Burn)
	
func is_on_fire():
	return $Burn.visible

func _on_area_entered(collided_with):
	if collided_with is UFO:
		if collided_with.is_on_fire():
			set_on_fire()

func _on_visible_on_screen_notifier_2d_screen_exited():
	reverse()

func show_sprite(sprite: Sprite2D):
	$Ufo.hide()
	$Burn.hide()
	$Exploded.hide()
	$Zapped.hide()
	sprite.show()
	
func _on_ufo_fire_timer_timeout():
	if is_dead():
		return
		
	if is_on_fire():
		return
		
	target_path.progress_ratio = randf()
	fire(bullet_scene, target_path.position)
