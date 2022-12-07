extends Node

var current_scene_name = "LocalEntities"

func switch_scene(new_scene_path):
	var new_scene = load(new_scene_path).instance()
	var world = get_tree().get_root().get_node("World")
	var player = world.get_node("TranientEntities/Player")
	var current_scene = world.get_node(current_scene_name)
	
	world.remove_child(current_scene)
	world.add_child(new_scene)
	player.position = world.get_node(new_scene.name + "/PlayerStart").position
	current_scene_name = new_scene.name
