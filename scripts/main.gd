extends Node2D
class_name MainScene

const UFOS_PER_LEVEL: int = 3

var RoundSuccessScene = preload("res://scenes/round_success.tscn")

@onready var screensize = get_viewport_rect().size
@onready var scoreLabel = $Score
@onready var levelLabel = $Level

var level_score = 0

func gen_random_pos():
	var x = randf_range(60, screensize.x-60)
	var y = randf_range(60, screensize.y / 2)
	return Vector2(x, y)
	
func create_ufo():
	var ufo = preload("res://scenes/ufo.tscn").instantiate()
	ufo.position = gen_random_pos()
	ufo.scale = Vector2(2, 2)
	ufo.target_path = $UFOTargetPath/PathFollow2D.duplicate()
	ufo.add_to_group("ufos")
	add_child(ufo)
	
func _ready():
	request_ready()
	
	var num_ufos = UFOS_PER_LEVEL * Global.level
	print("Creating %d ufos" % [num_ufos])
	for ufo_idx in num_ufos:
		create_ufo()

	for ufo in get_tree().get_nodes_in_group("ufos"):
		ufo.health_depleted.connect(_on_ufo_health_depleted)
		
	Global.delta_score.connect(_on_score_change)

func _process(_delta):
	if scoreLabel:
		scoreLabel.values = [Global.score]
	if levelLabel:
		levelLabel.values = [Global.level]

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mouse_position = get_global_mouse_position()
				get_tree().call_group("weapons", "fire", mouse_position)

	if event.is_action_pressed("weapon_switch"):
		get_tree().call_group("weapons", "next_weapon")
	
func _on_ufo_health_depleted(_ufo: UFO):
	Global.score += 1

func _on_score_change(change_amount: int):
	var score_goal = Global.level * UFOS_PER_LEVEL
	level_score += change_amount
	
	if level_score >= score_goal:
		get_tree().change_scene_to_packed(RoundSuccessScene)
