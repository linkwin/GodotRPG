extends Node
var save_file = "res://db/savedscene.tscn"

export(Resource) var world_save = preload("res://Resource/WorldSaveState.tres")

var current_scene_name = "LocalEntities"

onready var world = get_tree().get_root().get_node("World")

func load_world():
	#current_scene_name = world_save.current_scene
	world.load_entities()

func save_world():
	world_save.current_scene = current_scene_name
	world_save.save_world(world)
	world_save.save_transient_entities(world.get_node("TranientEntities"))

func cache_current_scene():
	world_save.cache_scene(world.get_node(current_scene_name))

func set_children_owned_recursive(parent):
	if parent.get_child_count() > 0:
		for node in parent.get_children():
			set_children_owned_recursive(node)
	else:
		parent.set_owner(parent.get_parent())

func switch_scene(new_scene_path, door_name, target_door_name):
	var new_scene = null
	var player = world.get_node("TranientEntities/Player")
	var current_scene = world.get_node(current_scene_name)
	world.get_node("TranientEntities/Player").remove_child(player)
	
	new_scene = world_save.fetch_scene(new_scene_path)
	world_save.cache_scene(current_scene)

	# Do scene switch
	world.remove_child(current_scene)
	world.add_child(new_scene)
	
	# Determine player start position
	var player_starts = []
	var player_start_node
	var prev_scene_name = current_scene_name
	for node in new_scene.get_tree().get_nodes_in_group("player_start"):
		if prev_scene_name == node.prev_scene:
			player_start_node = node
			player_starts.append(node)
	if player_starts.size() > 1:
		for node in player_starts:
			if target_door_name.empty():
				if door_name == node.door_name:
					player_start_node = node
			else:
				if target_door_name == node.door_name:
					player_start_node = node
	player.position = player_start_node.global_position
	current_scene_name = new_scene.name
	world.get_node("TranientEntities").add_child(player)
	
func save_node(node):
	print("saving " + str(node.name) + " node...")
	set_children_owned(node)
	var scene_pack = PackedScene.new()
	scene_pack.pack(node)
	ResourceSaver.save(save_file, scene_pack)
	
func load_world_save_state():
	#get_tree().get_root().remove_child(world)
	world.queue_free()
	get_tree().get_root().add_child(world_save.get_world_state_instance())
	
func show_one_child(parent, child):
	var parent_node = parent
	for node in parent_node.get_children():
		node.hide()
	child.show()
	
func hide_all_children(parent):
	for node in parent.get_children():
		node.hide()
		
func set_children_owned(parent):
	for node in parent.get_children():
		node.set_owner(parent)
