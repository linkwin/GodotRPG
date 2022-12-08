extends Node

var current_scene_name = "LocalEntities"

var cached_scenes = []

onready var world = get_tree().get_root().get_node("World")

func switch_scene(new_scene_path):
	var new_scene
	for scene in cached_scenes:
		if new_scene_path.find(scene.name) >= 0:
			new_scene = scene
	if new_scene == null:
		new_scene = load(new_scene_path).instance()
	var player = world.get_node("TranientEntities/Player")
	var current_scene = world.get_node(current_scene_name)
	cached_scenes.append(current_scene)
	world.remove_child(current_scene)
	world.add_child(new_scene)
	player.position = world.get_node(new_scene.name + "/PlayerStart").position
	current_scene_name = new_scene.name

func show_one_child(parent, child):
	var parent_node = parent
	for node in parent_node.get_children():
		node.hide()
	child.show()
	
func hide_all_children(parent):
	for node in parent.get_children():
		node.hide()
