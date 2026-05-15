extends Control


# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")

	elif event is InputEventScreenTouch and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
