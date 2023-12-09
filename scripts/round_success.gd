extends Node2D

var MainScene = preload("res://scenes/main.tscn")

var timer = 5.0

func _ready():
	pass

func _process(delta):
	if timer > 0:
		timer -= delta
		$Label.text = "%0.2f" % [timer]
	else:
		Global.level += 1
		get_tree().change_scene_to_packed(MainScene)
