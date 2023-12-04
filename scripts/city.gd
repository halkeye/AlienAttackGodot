extends Area2D
class_name City

@export_group("Health")
@export var health: int = 1 : set=set_health
@export var max_health:int = 1

@export_group("Images")
@export var full_health_image = preload("res://sprites/city/City.png")
@export var dead_image = preload("res://sprites/city/CityDie.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	$Sprite.set_texture(full_health_image)
	
func set_health(value : int) -> void:
	health = value
	if (health <= 0):
		$Sprite.set_texture(dead_image)
		health = 0
	else:
		$Sprite.set_texture(full_health_image)
		
func damage(amount: int = 1):
	health -= amount

func _process(_delta):
	pass
