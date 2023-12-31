extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("fire"):
		$LightningGenerator.generate(global_position, get_global_mouse_position())
