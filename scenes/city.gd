extends Node2D

@export_group("Health")
@export var health: int = 3 : set=set_health
@export var max_health:int = 3

@onready var image = preload("res://sprites/City.png")
@onready var dead_image = preload("res://sprites/CityDie.png")

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

func _on_left_wall_child_entered_tree(node):
	$"../UFO1".reverse()
	$"../UFO2".reverse()
	$"../UFO3".reverse()

func _on_right_wall_child_entered_tree(node):
	$"../UFO3".reverse()
	$"../UFO2".reverse()
	$"../UFO3".reverse()
