extends Node

@onready var grid = $MarginContainer/VBoxContainer/LevelMapping

var total_levels := 10  # change this to however many levels you have

func _ready():
	populate_levels()

func populate_levels():
	for i in range(total_levels):
		var button = Button.new()
		
		var level_id = i + 1
		
		# Set button text
		button.text = "Level %d" % level_id
		
		# Optional: make buttons expand nicely
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		# Connect signal with bound parameter
		button.pressed.connect(_on_level_button_pressed.bind(level_id))
		
		# Add to GridContainer
		grid.add_child(button)
		
func _on_level_button_pressed(level_id):
	var level_path = "res://scenes/levels/level_%d.tscn" % level_id
	var scene = load(level_path)
	
	if scene:
		get_tree().change_scene_to_packed(scene)
	else:
		print("Level not found: ", level_path)
