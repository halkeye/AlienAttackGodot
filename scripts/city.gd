extends Area2D
class_name City

@export_group("Images")
@export var full_health_image = preload("res://sprites/city/City.png")
@export var dead_image = preload("res://sprites/city/CityDie.png")

signal health_depleted(city: City)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.set_texture(full_health_image)
		
func damage(amount: int = 1) -> bool:
	$HealthComponent.damage(amount)
	return true

func _process(_delta):
	pass

func _on_health_component_health_depleted():
	$Sprite.set_texture(dead_image)
	health_depleted.emit(self)
	
func is_dead() -> bool:
	return $HealthComponent.is_dead()
