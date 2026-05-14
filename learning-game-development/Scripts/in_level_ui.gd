extends Control

@onready var back_to_menu: Button = $MarginContainer/VBoxContainer/HBoxContainer/BackToMenu
@onready var undo: Button = $MarginContainer/VBoxContainer/HBoxContainer/Undo
@onready var moves_label: Label = $MovesLabel
@onready var mute_sound: Button = $MarginContainer/VBoxContainer/HBoxContainer/MuteSound
@onready var mute_music: Button = $MarginContainer/VBoxContainer/HBoxContainer/MuteMusic


var level

func _ready() -> void:
	back_to_menu.pressed.connect(_on_back_to_menu_pressed)
	# Get reference to level (parent node)
	level = get_tree().current_scene
	print(level)
	
	if level.has_signal("moves_changed"):
		level.moves_changed.connect(update_moves)

	update_moves()

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
