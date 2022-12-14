extends Node
var save_file = "res://db/savedscene.tscn"

export(Resource) var world_save = preload("res://Resource/WorldSaves/WorldSaveState.tres")

var current_scene_name = "LocalEntities"

onready var world = get_tree().get_root().get_node("World")


func load_world(save_name):
	#current_scene_name = world_save.current_scene
	print("Loading save game: " + str(save_name))
	world_save = load("res://Resource/WorldSaves/" + save_name + ".tres")
	world.world_save_state = world_save
	world.load_entities()

func save_world(save_name):
	var dir = Directory.new()
	var new_save = null
	
	if !dir.dir_exists("res://db/" + save_name + "/"):
		dir.open("res://db/")
		dir.make_dir(save_name)
		new_save = world_save.duplicate()
		new_save.save_slot_name = "WorldSaveState_" + str(get_num_files_in_dir("res://Resource/WorldSaves/") + 1)
	else:
		new_save = load("res://Resource/WorldSaves/" + save_name + ".tres")
	
	var data = get_viewport().get_texture().get_data()
	data.flip_y()

	data.save_png("res://db/" + new_save.save_slot_name + "/" + "preview.png")
	new_save.save_slot_preview_path = "res://db/" + new_save.save_slot_name + "/" + "preview.png"
	
	for scene in world_save.cached_scenes:
		new_save.cache_scene(scene)
	new_save.cache_scene(world.get_node(current_scene_name))
	new_save.current_scene = current_scene_name
	new_save.save_world(world)
	new_save.save_transient_entities(world.get_node("TranientEntities"))

#	world_save.current_scene = current_scene_name
#	world_save.save_world(world)
#	world_save.save_transient_entities(world.get_node("TranientEntities"))

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
	
func get_preview_path():
	return world_save.save_slot_preview_path
	
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
		
		
		
func get_num_files_in_dir(path):
	var file_count = 0
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				file_count += 1
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return file_count

func get_files_in_dir(path):
	var files = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return files
