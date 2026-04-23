extends Node2D

func _process(delta):
	check_win_condition()


func check_win_condition():
	var org_exists = false
	var gmo_exists = false

	for node in get_tree().get_nodes_in_group("items"):
		if not node.has_method("get_type"):
			continue

		var t = node.get_type()

		if t == node.Type.FRUIT_ORG:
			org_exists = true
		elif t == node.Type.FRUIT_GMO:
			gmo_exists = true

	if not org_exists or not gmo_exists:
		win_level()


func win_level():
	print("Level Complete!")

	var menu_path="res://Scenes/menus/level_select.tscn"
	var scene = load(menu_path)
	
	if scene:
		get_tree().change_scene_to_packed(scene)
