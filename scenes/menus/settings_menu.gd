class_name SettingsMenu extends CanvasLayer

@onready var master_audio_stream_player : AudioStreamPlayer = $MasterAudioStreamPlayer
@onready var master_volume_slider_label : Label = %MasterVolumeSliderLabel
@onready var master_volume_slider : HSlider = %MasterVolumeSlider

@onready var music_audio_stream_player : AudioStreamPlayer = $MusicAudioStreamPlayer
@onready var music_volume_slider_label : Label = %MusicVolumeSliderLabel
@onready var music_volume_slider : HSlider = %MusicVolumeSlider

@onready var sfx_audio_stream_player : AudioStreamPlayer = $SFXAudioStreamPlayer
@onready var sfx_volume_slider_label : Label = %SFXVolumeSliderLabel
@onready var sfx_volume_slider : HSlider = %SFXVolumeSlider

@onready var user_preferences : UserPreferences = UserPreferences.load_or_create()

signal menu_done

# Called when the node enters the scene tree for the first time.
func _ready():	
	_master_value_changed(db_to_linear(AudioServer.get_bus_volume_db(UserPreferences.MASTER_BUS_IDX)))
	_music_value_changed(db_to_linear(AudioServer.get_bus_volume_db(UserPreferences.MUSIC_BUS_IDX)))
	_sfx_value_changed(db_to_linear(AudioServer.get_bus_volume_db(UserPreferences.SFX_BUS_IDX)))
	
func _master_value_changed (value: float): 
	master_volume_slider_label.text = str(floor(value*100)) + "%"
	master_volume_slider.value = value
	AudioServer.set_bus_volume_db(UserPreferences.MASTER_BUS_IDX, linear_to_db(value))

func _music_value_changed (value: float): 
	music_volume_slider_label.text = str(floor(value*100)) + "%"
	music_volume_slider.value = value
	AudioServer.set_bus_volume_db(UserPreferences.MUSIC_BUS_IDX, linear_to_db(value))

func _sfx_value_changed(value: float): 
	sfx_volume_slider_label.text = str(floor(value*100)) + "%"
	sfx_volume_slider.value = value
	AudioServer.set_bus_volume_db(UserPreferences.SFX_BUS_IDX, linear_to_db(value))
				
func _on_music_button_pressed():
	if !music_audio_stream_player.playing:
		music_audio_stream_player.play()
	else:
		music_audio_stream_player.stop()

func _on_sfx_button_pressed():
	if !sfx_audio_stream_player.playing:
		sfx_audio_stream_player.play()
	else:
		sfx_audio_stream_player.stop()

func _on_done_button_pressed():
	user_preferences.setup_audio_busses()	
	menu_done.emit()
	queue_free()

func _on_save_button_pressed():
	if master_volume_slider:
		user_preferences.master_audio_level = master_volume_slider.value
	if sfx_volume_slider:
		user_preferences.sfx_audio_level = sfx_volume_slider.value
	if music_volume_slider:
		user_preferences.music_audio_level = music_volume_slider.value
	user_preferences.save()
	menu_done.emit()
	queue_free()
