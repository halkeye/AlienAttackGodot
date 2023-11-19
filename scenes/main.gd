extends Node2D

@export var bullet_scene: PackedScene
@export var ufos : Array[UFO] = []

var score = 0

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
#	$"RightWall/CollisionShape2D".position.y = viewport.size.y / 2
	for ufo in ufos:
		ufo.health_depleted.connect(_on_ufo_health_depleted)
	pass # Replace with function body.

func _process(delta):
	$"Score/Value".text = str(score)
	pass

func _on_right_wall_body_entered(body):
	if body.has_method("on_wall_hit"):
		body.on_wall_hit()
		
	if body is UFO:
		body.reverse()

func _on_left_wall_body_entered(body):
	if body is UFO:
		body.reverse()
		
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				print("_unhandled_input.event: ", event)
				var mouse_position = get_global_mouse_position()
				$Weapon.fire(bullet_scene, get_global_mouse_position())
				$Weapon2.fire(bullet_scene, get_global_mouse_position())

	if event is InputEventScreenTouch:
		if event.pressed:
			print("screen was touched at ", event.position)
		else:
			print("screen was released")


func _on_weapon_input_event(viewport, event, shape_idx):
	print("_on_weapon_input_event.event: ", event)
	print("_on_weapon_input_event.shape_idx: ", shape_idx)
	if event.is_action_pressed("switch"):
		$Weapon.gun_type = $Weapon.gun_type + 1
		$Weapon2.gun_type = $Weapon2.gun_type + 1


func _on_ufo_fire_timer_timeout():
	if len(ufos) == 0:
		## there should never be no ufos normally, but guard incase
		return
		
	var ufo = ufos[randi_range(0, len(ufos)-1)]
	$UFOTargetPath/PathFollow2D.progress_ratio = randf()
	var bullet = ufo.fire(bullet_scene, $UFOTargetPath/PathFollow2D.position)
	
func _on_ufo_health_depleted(ufo: UFO):
	var idx = ufos.find(ufo)
	ufos.remove_at(idx)
	score += 1
