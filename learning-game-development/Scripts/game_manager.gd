extends Node

var is_story_mode := false
var current_level := 1

func start_story_mode():
	is_story_mode = true
	current_level = 1
	load_level(current_level)


func start_free_play():
	is_story_mode = false
	get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")


func load_level(level:int):
	current_level = level
	
	var path = "res://Scenes/levels/level_%d.tscn" % level
	
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		print("No more levels!")
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")


func load_next_level():
	current_level += 1
	load_level(current_level)
