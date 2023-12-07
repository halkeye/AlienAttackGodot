extends Control

var MainScene = preload("res://scenes/main.tscn")

func _ready():
	$MarginContainer/HBoxContainer/VBoxContainer/Version.text = "Version: " + Version.versionHash
	
func _process(_delta):
	pass

func _on_new_game_pressed():
	get_tree().change_scene_to_packed(MainScene)
	
func _on_how_to_play_pressed():
	$"How To Play".show()

func _on_how_to_play_on_close():
	$"How To Play".hide()
