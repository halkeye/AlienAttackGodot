extends Area2D
class_name UFO

@onready var screensize = get_viewport_rect().size

var bullet_scene = preload("res://scenes/bullet.tscn")

signal health_depleted(ufo: UFO)

var speed = 150
var velocity = Vector2.ZERO

 # wait 1 second before every 2 seconds
var last_fire = -1

# Called when the node enters the scene tree for the first time.
func _ready():		
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
	
func damage(amount: int = 1) -> bool:
	return $HealthComponent.damage(amount)
	
func is_dead() -> bool:
	return $HealthComponent.is_dead()
	
func fire(pos: Vector2):
	if $HealthComponent.is_dead():
		return
		
	var bullet = bullet_scene.instantiate() as Bullet
	var starting_pos = $".".global_position
	bullet.set_collision_mask(1 << 2)
	bullet.start(starting_pos, (pos - starting_pos).angle())
	get_tree().root.add_child(bullet)
	return bullet
	
func reverse():
	speed = -1 * speed 
	velocity = Vector2(speed, 0)
	if $HealthComponent.is_dead():
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
	if $HealthComponent.is_dead():
		return
		
	if is_on_fire():
		return
	
	fire(Vector2(randf_range(0, screensize.x), screensize.y))

func _on_health_component_health_depleted():
	show_sprite($Exploded)
	health_depleted.emit(self)
