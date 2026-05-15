extends Control

@onready var back_to_menu: Button = $MarginContainer/VBoxContainer/HBoxContainer/BackToMenu
@onready var undo: Button = $MarginContainer/VBoxContainer/HBoxContainer/Undo
@onready var moves_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect/MovesLabel
@onready var mute_sound: Button = $MarginContainer/VBoxContainer/HBoxContainer/MuteSound
@onready var mute_music: Button = $MarginContainer/VBoxContainer/HBoxContainer/MuteMusic
@onready var local_label: Label = $"MarginContainer/VBoxContainer/Counter Container/VBoxContainer/Couner_Local/localLabel"
@onready var convenient_label: Label = $"MarginContainer/VBoxContainer/Counter Container/VBoxContainer/Counter_Convenient/convenientLabel"


var level

func _ready() -> void:
	back_to_menu.pressed.connect(_on_back_to_menu_pressed)
	# Get reference to level (parent node)
	level = get_tree().current_scene
	print(level)
	
	if level.has_signal("moves_changed"):
		level.moves_changed.connect(update_moves)
	if level.has_signal("fruits_changed"):
		level.fruits_changed.connect(_on_fruits_changed)
		
		_on_fruits_changed(level.get_org_fruits(), level.get_gmo_fruits())
	update_moves()
	undo.pressed.connect(_undo_pressed)
	mute_music.pressed.connect(_mute_music)
	mute_sound.pressed.connect(_mute_sound)

func _on_back_to_menu_pressed() -> void:
	if GameManager.is_tutorial or GameManager.is_story_mode:
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")
		
func update_moves():
	if level == null:
		return
		
	if not level.has_method("get_moves"):
		return

	var moves = level.get_moves()
	moves_label.text = str(moves)
	
func _undo_pressed():
	get_tree().reload_current_scene()
	
func _mute_music():
	if(CoreGameplayMusic.playing):
		CoreGameplayMusic.stop()
		mute_music.icon = load("res://Assets/Graphics/UI/main menu screen/button_music_off.png")
	else:
		CoreGameplayMusic.play()
		mute_music.icon = load("res://Assets/Graphics/UI/main menu screen/button_music_on.png")

@onready var icon_on = preload("res://Assets/Graphics/UI/main menu screen/button_sound_on.png")
@onready var icon_off = preload("res://Assets/Graphics/UI/main menu screen/button_sound_off.png")

func _mute_sound():
	var sfx_bus = AudioServer.get_bus_index("SFX")
	var new_state = !AudioServer.is_bus_mute(sfx_bus)

	AudioServer.set_bus_mute(sfx_bus, new_state)
	mute_sound.icon = icon_off if new_state else icon_on

func _on_fruits_changed(org_count, gmo_count):
	local_label.text = str(org_count)
	convenient_label.text = str(gmo_count)
