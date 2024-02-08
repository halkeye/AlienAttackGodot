extends Control

var MainScene = preload("res://scenes/main.tscn")
var SettingsScene = preload("res://scenes/menus/settings_menu.tscn")

func _ready():
	UserPreferences.load_or_create().setup_audio_busses()
	%Version.text = "Version: " + Version.versionHash.substr(0, 6)
	%Version.uri = "https://github.com/halkeye/AlienAttackGodot/tree/" + Version.versionHash.uri_encode()

func _on_new_game_pressed():
	get_tree().change_scene_to_packed(MainScene)
	
func _on_how_to_play_pressed():
	$"How To Play".show()

func _on_how_to_play_on_close():
	$"How To Play".hide()

func _on_settings_pressed():
	var settings_menu = SettingsScene.instantiate()
	get_tree().get_root().add_child(settings_menu)
	var done_settings := func():
		settings_menu.queue_free()
	settings_menu.menu_done.connect(done_settings)

func _on_credits_pressed():
	get_tree().change_scene_to_packed(load("res://scenes/menus/credits.tscn"))
