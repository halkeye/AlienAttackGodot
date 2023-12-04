extends Node2D

@export var bullet_scene: PackedScene

#@onready var ufos : Array[Node] = get_tree().get_nodes_in_group("ufos")

var score = 0

@onready var screensize = get_viewport_rect().size

@onready var scoreLabel = $"Score/Value"

func gen_random_pos():
	var x = randf_range(60, screensize.x-60)
	var y = randf_range(60, screensize.y / 2)
	return Vector2(x, y)
	
func create_ufo():
	var ufo = preload("res://scenes/ufo.tscn").instantiate()
	ufo.position = gen_random_pos()
	ufo.scale = Vector2(2, 2)
	ufo.add_to_group("ufos")
	add_child(ufo)
	
func _ready():
	create_ufo()
	create_ufo()
	create_ufo()
	for ufo in get_tree().get_nodes_in_group("ufos"):
		ufo.health_depleted.connect(_on_ufo_health_depleted)

func _process(_delta):
	if scoreLabel:
		scoreLabel.text = str(score)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_position = get_global_mouse_position()
				get_tree().call_group("weapons", "fire", bullet_scene, mouse_position)

	if event.is_action_pressed("weapon_switch"):
		get_tree().call_group("weapons", "next_weapon")

func _on_ufo_fire_timer_timeout():
	var ufos = get_tree().get_nodes_in_group("ufos")
	if len(ufos) == 0:
		## there should never be no ufos normally, but guard incase
		return
		
	var ufo: UFO = ufos[randi_range(0, len(ufos)-1)]
	if !ufo.is_dead():
		$UFOTargetPath/PathFollow2D.progress_ratio = randf()
		ufo.fire(bullet_scene, $UFOTargetPath/PathFollow2D.position)
	
func _on_ufo_health_depleted(ufo: UFO):
	score += 1
