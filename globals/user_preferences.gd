class_name UserPreferences extends Resource

@export_range(0, 1, 0.01) var music_audio_level: float = 0.5
@export_range(0, 1, 0.01) var sfx_audio_level: float = 1.0

func save():
	ResourceSaver.save(self, "user://user_prefs.tres")
	return self
	
func setup_audio_busses():
	AudioServer.set_bus_volume_db(Global.MUSIC_BUS_IDX, linear_to_db(music_audio_level))
	AudioServer.set_bus_volume_db(Global.SFX_BUS_IDX, linear_to_db(sfx_audio_level))
	return self
	
static func load_or_create() -> UserPreferences:
	var user_preferences : UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !user_preferences:
		user_preferences = UserPreferences.new()
	
	return user_preferences

