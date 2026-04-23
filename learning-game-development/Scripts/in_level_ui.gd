extends Control

@onready var back_to_menu: Button = $MarginContainer/HBoxContainer/BackToMenu
@onready var moves_label: Label = $MarginContainer/HBoxContainer/MovesLabel


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
	get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")

func update_moves():
	if level == null:
		return
		
	if not level.has_method("get_moves"):
		return

	var moves = level.get_moves()
	moves_label.text = "Moves: %d" % moves
