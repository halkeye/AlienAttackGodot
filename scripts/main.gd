extends Node2D
class_name MainScene

var round_success_scene = preload("res://scenes/round_success.tscn")
var round_defeat_scene = preload("res://scenes/round_defeat.tscn")
var ufo_scene = preload("res://scenes/ufo.tscn")

@onready var screensize = get_viewport_rect().size
@onready var scoreLabel = $Score
@onready var levelLabel = $Level

@export var level = 1
@export var score = 0
var level_score = 0

const UFOS_PER_LEVEL: int = 3

func gen_random_pos():
	var x = randf_range(60, screensize.x-60)
	var y = randf_range(60, screensize.y / 2)
	return Vector2(x, y)
	
func create_ufo():
	var ufo = ufo_scene.instantiate()
	ufo.position = gen_random_pos()
	ufo.scale = Vector2(2, 2)
	ufo.add_to_group("ufos")
	add_child(ufo)
	
func _ready():
	request_ready()
	
	var num_ufos = UFOS_PER_LEVEL * level
	print("Creating %d ufos" % [num_ufos])
	for ufo_idx in num_ufos:
		create_ufo()

	for ufo in get_tree().get_nodes_in_group("ufos"):
		ufo.health_depleted.connect(_on_ufo_health_depleted)
		
	for city in get_tree().get_nodes_in_group("cities"):
		city.health_depleted.connect(_on_city_health_depleted)

func _process(_delta):
	if scoreLabel:
		scoreLabel.values = [score, score_goal(level)]
	if levelLabel:
		levelLabel.values = [level]

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_position = get_global_mouse_position()
				get_tree().call_group("weapons", "fire", mouse_position)

	if event.is_action_pressed("weapon_switch"):
		get_tree().call_group("weapons", "next_weapon")
	
func _on_ufo_health_depleted(_ufo: UFO):
	score += 1
	
func _on_city_health_depleted(_city: City):
	var cities_alive = false
	for city in get_tree().get_nodes_in_group("cities"):
		if !city.is_dead():
			cities_alive = true
	if !cities_alive:
		get_tree().change_scene_to_packed(round_defeat_scene)

func score_goal(level: int):
	return level * UFOS_PER_LEVEL

func _on_child_exiting_tree(node):
	if node is UFO:
		# No more ufos left on this level (aka last one)
		if get_tree().get_nodes_in_group("ufos").size() == 1:
			get_tree().change_scene_to_packed(round_success_scene)
			## TODO -
				# Popup success message
				# Click continue
				# reset score and stuff
				# _ready
