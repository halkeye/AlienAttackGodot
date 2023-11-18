extends Node2D

@export var bullet_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport = get_viewport_rect()

	$"LeftWall/CollisionShape2D".shape.size.x = 4
	$"LeftWall/CollisionShape2D".shape.size.y = viewport.size.y
	$"LeftWall/CollisionShape2D".position.x = 2
	$"LeftWall/CollisionShape2D".position.y = viewport.size.y / 2
	
	$"RightWall/CollisionShape2D".shape.size.x = 4
	$"RightWall/CollisionShape2D".shape.size.y = viewport.size.y
	$"RightWall/CollisionShape2D".position.x = viewport.size.x - 2
	$"RightWall/CollisionShape2D".position.y = viewport.size.y / 2
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
				var mouse_position = get_global_mouse_position()
				$Weapon.fire(bullet_scene, get_global_mouse_position())
				$Weapon2.fire(bullet_scene, get_global_mouse_position())

	if event is InputEventScreenTouch:
		if event.pressed:
			print("screen was touched at ", event.position)
		else:
			print("screen was released")
