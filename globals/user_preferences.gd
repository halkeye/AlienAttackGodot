class_name UserPreferences extends Resource


static var MASTER_BUS_IDX = AudioServer.get_bus_index("Master")
static var MUSIC_BUS_IDX = AudioServer.get_bus_index("Music")
static var SFX_BUS_IDX = AudioServer.get_bus_index("SFX")

@export_range(0, 1, 0.01) var master_audio_level: float = 0.5
@export_range(0, 1, 0.01) var music_audio_level: float = 0.5
@export_range(0, 1, 0.01) var sfx_audio_level: float = 1.0

func save():
	ResourceSaver.save(self, "user://user_prefs.tres")
	return self
	
func setup_audio_busses():
	AudioServer.set_bus_volume_db(UserPreferences.MASTER_BUS_IDX, linear_to_db(master_audio_level))
	AudioServer.set_bus_volume_db(UserPreferences.MUSIC_BUS_IDX, linear_to_db(music_audio_level))
	AudioServer.set_bus_volume_db(UserPreferences.SFX_BUS_IDX, linear_to_db(sfx_audio_level))
	return self
	
static func load_or_create() -> UserPreferences:
	var user_preferences : UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !user_preferences:
		user_preferences = UserPreferences.new()
		user_preferences.master_audio_level = db_to_linear(AudioServer.get_bus_volume_db(UserPreferences.MASTER_BUS_IDX))
		user_preferences.music_audio_level = db_to_linear(AudioServer.get_bus_volume_db(UserPreferences.MUSIC_BUS_IDX))
		user_preferences.sfx_audio_level = db_to_linear(AudioServer.get_bus_volume_db(UserPreferences.SFX_BUS_IDX))
		
	return user_preferences

