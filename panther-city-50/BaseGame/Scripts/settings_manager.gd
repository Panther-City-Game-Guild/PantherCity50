extends Control

### VARIABLES ###
# Where settings get saved
const CONFIG_PATH = "user://config.ini"

# Define various sections in the Config File
const VOLUME_SECTION = "Volume Settings"
const GLOBAL_SECTION = "Global Settings"

# Volume min and Volume max
const VOLUME_RANGE = [ 0, 100 ]

# Default volume settings; used on first load or corrupted config file
const DEFAULT_VOLUME_SETTINGS: Dictionary =  {
	"master_volume": 70,		# 0-100
	"music_volume": 10,			# 0-100
	"fx_volume": 70,			# 0-100
}

### FUNCTIONS ###
# Called to verify integer settings values
func verifySettingInt(i: int, array: Array) -> int:
	# Check if i is an int and if it's within the correct range
	if i is int && i >= array[0] && i <= array[1]:
		return i
	else:
		return array[0]

# Called to load saved or default volume settings
func loadVolumeSettings() -> void:
	var config_file := ConfigFile.new()
	var err := config_file.load(CONFIG_PATH)
	
	# Exit function if error (e.g., when no file exists)
	if err != OK:
		Globals.Current_Volume_Settings.master_volume = DEFAULT_VOLUME_SETTINGS.master_volume
		Globals.Current_Volume_Settings.music_volume = DEFAULT_VOLUME_SETTINGS.music_volume
		Globals.Current_Volume_Settings.fx_volume = DEFAULT_VOLUME_SETTINGS.fx_volume
		saveVolumeSettings()
		return
	
	# Retrieve saved volume settings
	Globals.Current_Volume_Settings.master_volume = verifySettingInt(config_file.get_value(VOLUME_SECTION, "master", DEFAULT_VOLUME_SETTINGS.master_volume), VOLUME_RANGE)
	Globals.Current_Volume_Settings.music_volume = verifySettingInt(config_file.get_value(VOLUME_SECTION, "music", DEFAULT_VOLUME_SETTINGS.music_volume), VOLUME_RANGE)
	Globals.Current_Volume_Settings.fx_volume = verifySettingInt(config_file.get_value(VOLUME_SECTION, "fx", DEFAULT_VOLUME_SETTINGS.fx_volume), VOLUME_RANGE)

# Called when a volume setting is changed
func saveVolumeSettings() -> void:
	var config_file := ConfigFile.new()
	config_file.set_value(VOLUME_SECTION, "master", int(Globals.Current_Volume_Settings.master_volume))
	config_file.set_value(VOLUME_SECTION, "music", int(Globals.Current_Volume_Settings.music_volume))
	config_file.set_value(VOLUME_SECTION, "fx", int(Globals.Current_Volume_Settings.fx_volume))
	config_file.save(CONFIG_PATH)

# Called to update various volume sliders
func updateVolumeSliders() -> void:
	$PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/MasterVBox/MasterVolumeSlider.value = Globals.Current_Volume_Settings.master_volume
	$PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/MusicVBox/MusicVolumeSlider.value = Globals.Current_Volume_Settings.music_volume
	$PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/FXVBox/FXVolumeSlider.value = Globals.Current_Volume_Settings.fx_volume

# Called to update the volume labels with associated sliders
func updateVolumeLabels() -> void:
	$PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/MasterVBox/MasterHBox/MasterVolLbl.text = str(Globals.Current_Volume_Settings.master_volume)
	$PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/MusicVBox/MusicHBox/MusicVolLbl.text = str(Globals.Current_Volume_Settings.music_volume)
	$PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/FXVBox/FXHBox/FXVolLbl.text = str(Globals.Current_Volume_Settings.fx_volume)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide() 					# Hide the SettingsManager by default
	loadVolumeSettings()	# Load the saved settings, or defaults
	updateVolumeSliders()	# Update volume sliders to reflect values
	updateVolumeLabels()	# Update volume labels to reflect values

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# When the SettingsManager is closed, save the settings
	if Input.is_action_just_pressed("ui_cancel"):
		hide()
		saveVolumeSettings()

# Called when the 'X' button is pressed in the window
func _on_button_pressed() -> void:
	hide()
	saveVolumeSettings()

# Called when the user changes the MasterVolumeSlider
func _on_master_volume_slider_value_changed(value: float) -> void:
	Globals.Current_Volume_Settings.master_volume = $PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/MasterVBox/MasterVolumeSlider.value
	updateVolumeLabels()

# Called when the user changes the MusicVolumeSlider
func _on_music_volume_slider_value_changed(value: float) -> void:
	Globals.Current_Volume_Settings.music_volume = $PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/MusicVBox/MusicVolumeSlider.value
	updateVolumeLabels()

# Called when the user changes the FXVolumeSlider
func _on_fx_volume_slider_value_changed(value: float) -> void:
	Globals.Current_Volume_Settings.fx_volume = $PanelContainer/SettingsOuterVBox/SettingsHBox/VBoxLeft/FXVBox/FXVolumeSlider.value
	updateVolumeLabels()
