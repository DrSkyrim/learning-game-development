extends Node

var is_story_mode := false
var current_level := 1
var current_tutorial_level := 1
var is_tutorial := false
var story_index := 0

var reward_level_array := [0,0,0,0,0,0,0,0,0,0]

func start_story_mode():
	is_story_mode = true
	is_tutorial = false
	current_level = 1
	story_index = 0
	reset_rewards()
		
	get_tree().change_scene_to_file("res://Scenes/menus/story_node.tscn")

func start_tutorial():
	is_story_mode = false
	is_tutorial = true
	reset_rewards()
	current_tutorial_level = 1
	#load_tutorial_level(current_tutorial_level)
	get_tree().change_scene_to_file("res://Scenes/menus/story_node.tscn")

func start_free_play():
	is_story_mode = false
	is_tutorial = false
	reset_rewards()
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
	
func _input(event):
	if event.is_action_released("kill_app"):
		get_tree().quit()

func load_tutorial_level(level: int):
	var path = "res://Scenes/levels/tutorial/level_%d.tscn" % level
	
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)
	else:
		print("No more levels!")
		get_tree().change_scene_to_file("res://Scenes/menus/level_select.tscn")
		
func load_next_tutorial():
	current_tutorial_level += 1
	load_tutorial_level(current_tutorial_level)
	
func get_story_image_path() -> String:
	match story_index:
		0:
			return "res://Assets/Graphics/cutscenes/cutscene_intro.png"
		1:
			return "res://Assets/story/story_1.png"
		2:
			return "res://Assets/story/story_2.png"
		_:
			return ""
			
func reset_rewards():
	var rewards = reward_level_array.size()
	for index in rewards:
		reward_level_array[index] = 0
