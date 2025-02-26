extends Node

# This global will keep track of Scene names for easy switching
@onready var BaseGameTitle := "res://BaseGame/Scenes/Title.tscn"
@onready var SettingsManager := "res://BaseGame/Scenes/settings_manager.tscn"
@onready var GameSelection := "res://BaseGame/Scenes/game_selection.tscn"
@onready var GameRootScene := "res://BaseGame/Scenes/GameRoot.tscn"

# Panther Run Scenss
@onready var PantherRunTitle := "res://PantherRun/Scenes/PantherRunTitle.tscn"

# Panther Escape Scenes 
@onready var ZETitle := "res://ZooEscape/Scenes/ZETitle.tscn"
@onready var ZEDebug := "res://ZooEscape/Scenes/ZEDebug.tscn"
@onready var ZEDebug2 := "res://ZooEscape/Scenes/ZEDebug2.tscn"

# Simon Scenes
@onready var SimonTitle := "res://Simon/Scenes/SimonTitle.tscn"

# Drifter Scenes
@onready var DrifterTitle := "res://Drifter/Scenes/TitleScreen.tscn"
@onready var DrifterPlay := "res://Drifter/Scenes/PlayScreen.tscn"
