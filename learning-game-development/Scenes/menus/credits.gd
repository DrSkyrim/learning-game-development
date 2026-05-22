extends Control
func _ready() -> void:
	CoreGameplayMusic.stop()
	MenuMusic.stop()
	%OutroMusic.play()

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")

	elif event is InputEventScreenTouch and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/menus/main_menu.tscn")
