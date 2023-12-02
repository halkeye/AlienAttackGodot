extends Node2D

@export var bullet_scene: PackedScene

#@onready var ufos : Array[Node] = get_tree().get_nodes_in_group("ufos")

var score = 0

@onready var screensize = get_viewport_rect().size

@onready var scoreLabel = $"Score/Value"

func _ready():
#	var viewport = get_viewport_rect()
#	$"LeftWall/CollisionShape2D".shape.size.x = 4
#	$"LeftWall/CollisionShape2D".shape.size.y = viewport.size.y
#	$"LeftWall/CollisionShape2D".position.x = 2
#	$"LeftWall/CollisionShape2D".position.y = viewport.size.y / 2
#
#	$"RightWall/CollisionShape2D".shape.size.x = 4
#	$"RightWall/CollisionShape2D".shape.size.y = viewport.size.y
#	$"RightWall/CollisionShape2D".position.x = viewport.size.x - 2
#	$"RightWall/CollisionShape2D".position.y = viewport.size.y / 2+
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

	if event is InputEventScreenTouch:
		if event.pressed:
			print("screen was touched at ", event.position)
		else:
			print("screen was released")

	if event.is_action_pressed("weapon_switch"):
		get_tree().call_group("weapons", "next_weapon")

func _on_ufo_fire_timer_timeout():
	var ufos = get_tree().get_nodes_in_group("ufos")
	if len(ufos) == 0:
		## there should never be no ufos normally, but guard incase
		return
		
	var ufo = ufos[randi_range(0, len(ufos)-1)]
	$UFOTargetPath/PathFollow2D.progress_ratio = randf()
	ufo.fire(bullet_scene, $UFOTargetPath/PathFollow2D.position)
	
func _on_ufo_health_depleted(ufo: UFO):
	score += 1
