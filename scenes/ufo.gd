extends Node2D

@export_group("Health")
@export var health: int = 1 : set=set_health
@export var max_health:int = 1

@onready var image = preload("res://sprites/UFO.png")
@onready var dead_image = preload("res://sprites/UFOBoom.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	$Sprite.set_texture(image)
	
func set_health(value : int) -> void:
	health += value
	if (health <= 0):
		$Sprite.set_texture(dead_image)
	else:
		$Sprite.set_texture(image)
	
func damage(amount: int = 1):
	health -= amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
