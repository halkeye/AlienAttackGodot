extends Node2D 
class_name MainScene

var ufo_scene = preload("res://scenes/ufo.tscn")

@onready var screensize = get_viewport_rect().size
@onready var scoreLabel = $Score
@onready var levelLabel = $Level

var level = 1
var score = 0

const UFOS_PER_LEVEL: int = 3

func gen_random_pos():
	var x = randf_range(60, screensize.x - 60)
	var y = randf_range(60, screensize.y / 3)
	return Vector2(x, y)
	
func create_ufo():
	var ufo = ufo_scene.instantiate() as UFO
	ufo.position = gen_random_pos()
	ufo.scale = Vector2(2, 2)
	ufo.add_to_group("ufos")
	if !ufo.health_depleted.is_connected(_on_ufo_health_depleted):
		ufo.health_depleted.connect(_on_ufo_health_depleted)
	add_child(ufo)
	
func _ready():
	create_ufos()
		
	for city in get_tree().get_nodes_in_group("cities"):
		city.health_depleted.connect(_on_city_health_depleted)

func create_ufos():
	var num_ufos = UFOS_PER_LEVEL * level
	for ufo_idx in num_ufos:
		create_ufo()
		
func _process(_delta):
	if scoreLabel:
		scoreLabel.values = [score, MainScene.score_goal(level)]
	if levelLabel:
		levelLabel.values = [level]

func _on_ufo_health_depleted(_ufo: UFO):
	score += 1
	var all_ufos = get_tree().get_nodes_in_group("ufos")
	var alive_ufos = all_ufos.filter(func(ufo: UFO): return !ufo.is_dead())
	# No more ufos left on this level (aka last one)
	if alive_ufos.size() == 0:
		get_tree().paused = true
		$RoundSuccess.show()
	
func _on_city_health_depleted(_city: City):
	var cities_alive = false
	for city in get_tree().get_nodes_in_group("cities"):
		if !city.is_dead():
			cities_alive = true
	if !cities_alive:
		get_tree().paused = true
		$RoundDefeat.show()

static func score_goal(target_level: int):
	var total = 0
	for lvl in range(1, target_level+1):
		total += lvl * UFOS_PER_LEVEL
	return total

func _on_round_success_next_level():
	# make sure they are all cleared off the screen before starting next round
	get_tree().call_group("ufos", "queue_free")

	$RoundSuccess.hide()
	get_tree().paused = false
	level += 1
	get_tree().call_group("ufos", "queue_free")
	get_tree().call_group("weapons", "reset")
	create_ufos()

func _on_round_defeat_back():
	get_tree().paused = false
	get_tree().change_scene_to_packed(load("res://scenes/menus/main_menu.tscn"))
