extends Node2D

@export var moves = 10
var org_fruit_count := 0
var gmo_fruit_count := 0

signal moves_changed
signal fruits_changed(org_count, gmo_count)

var current_story_moves := 0

func _ready():
	MenuMusic.stop()

	if not CoreGameplayMusic.playing:
		CoreGameplayMusic.play()

	for node in get_tree().get_nodes_in_group("items"):
		if not node.has_method("get_type"):
			continue

		var t = node.get_type()

		if t == node.Type.BASKET_ORG or t == node.Type.BASKET_GMO:
			node.moved.connect(_on_basket_moved)

		elif t == node.Type.FRUIT_ORG:
			org_fruit_count += 1

			node.tree_exiting.connect(func():
				SfxPickup.play()
				org_fruit_count -= 1
				emit_signal(
					"fruits_changed",
					org_fruit_count,
					gmo_fruit_count
				)
			)

		elif t == node.Type.FRUIT_GMO:
			gmo_fruit_count += 1

			node.tree_exiting.connect(func():
				SfxPickup.play()
				gmo_fruit_count -= 1
				emit_signal(
					"fruits_changed",
					org_fruit_count,
					gmo_fruit_count
				)
			)
	if (GameManager.is_story_mode):
		current_story_moves = GameManager.story_moves
		emit_signal("moves_changed")
	if (GameManager.is_casual_mode):
		moves = GameManager.casual_moves
		emit_signal("moves_changed")

	# Emit initial values once level loads
	emit_signal(
		"fruits_changed",
		org_fruit_count,
		gmo_fruit_count
	)


func _process(_delta):
	check_win_condition()


func _on_basket_moved():
	if (GameManager.is_casual_mode):
		moves += 1
	elif not GameManager.is_tutorial:
		if (GameManager.is_story_mode):
			current_story_moves -= 1
		else:
			moves -= 1
		if get_moves() <= 0:
			lose_level()
	emit_signal("moves_changed")


func check_win_condition():
	var org_exists = false
	var gmo_exists = false
	var org_not_org = 0  #0 = organic, 1 = non

	for node in get_tree().get_nodes_in_group("items"):
		if not node.has_method("get_type"):
			continue

		var t = node.get_type()

		if t == node.Type.FRUIT_ORG:
			org_exists = true
		elif t == node.Type.FRUIT_GMO:
			gmo_exists = true
	if (not org_exists or not gmo_exists) and get_moves() > 0:
		if(not org_exists):
			org_not_org = 0
			win_level(org_not_org)
		else:
			org_not_org = 1
			win_level(org_not_org)

func get_moves():
	if (GameManager.is_story_mode):
		return current_story_moves
	return moves
	
func get_org_fruits():
	return org_fruit_count
	
func get_gmo_fruits():
	return gmo_fruit_count

func win_level(org_not_org):
	CoreGameplayMusic.stop()
	print("Level Complete!")

	await get_tree().create_timer(0.5).timeout
	if(GameManager.is_tutorial):
		if(org_not_org == 0):
			GameManager.win_type = 0
		else:
			GameManager.win_type = 1
	else:
		var this_level = GameManager.current_level-1
		if(org_not_org == 0):
			GameManager.reward_level_array[this_level] = 2
			GameManager.win_type = 0
		else:
			GameManager.reward_level_array[this_level] = 1
			GameManager.win_type = 1
		if (GameManager.is_story_mode):
			GameManager.story_moves = current_story_moves
		elif (GameManager.is_casual_mode):
				GameManager.casual_moves = moves
		
	get_tree().change_scene_to_file("res://Scenes/menus/level_end_win_result.tscn")


func lose_level():
	CoreGameplayMusic.stop()
	await get_tree().create_timer(0.5).timeout

	get_tree().change_scene_to_file("res://Scenes/menus/level_end_loss.tscn")
	
