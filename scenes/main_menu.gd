extends MarginContainer

var MainScene = preload("res://scenes/main.tscn")

func _ready():
	pass 

func _process(_delta):
	pass

func _on_new_game_pressed():
	get_tree().change_scene_to_packed(MainScene)
