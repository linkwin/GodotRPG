extends Node
var save_file = "res://db/savedscene.tscn"

export(Resource) var world_save = preload("res://Resource/WorldSaves/WorldSaveState.tres")

var current_scene_name = "MainWorldSpace"

onready var world = get_tree().get_root().get_node("World")


func load_world(save_name):
	#current_scene_name = world_save.current_scene
	print("Loading save game: " + str(save_name))
	var prev_save = world_save
	world_save = load("res://Resource/WorldSaves/" + save_name + ".tres")
	if world_save != null:
		world.world_save_state = world_save
		world_save.clean_cached_scenes()
		world.load_entities(prev_save)

func save_world(save_name):
	var dir = Directory.new()
	var new_save = null
	
	if save_name == "NEW SAVE GAME":
		save_name = "WorldSaveState_" + str(get_num_files_in_dir("res://Resource/WorldSaves/") + 1)
	
	# check if save folder exists in db
	if dir.dir_exists("res://db/" + save_name + "/"):
		# if exists, load world save resource
		new_save = load("res://Resource/WorldSaves/" + save_name + ".tres")
	else:	
		# otherwise, create directory and new world save
		dir.open("res://db/")
		dir.make_dir(save_name)
		new_save = world_save.duplicate()
		new_save.save_slot_name = "WorldSaveState_" + str(get_num_files_in_dir("res://Resource/WorldSaves/") + 1)

	#screen shot, save and assign ref to save slot preview
	var data = get_viewport().get_texture().get_data()
	data.flip_y()
	data.save_png("res://db/" + new_save.save_slot_name + "/" + "preview.png")
	new_save.save_slot_preview_path = "res://db/" + new_save.save_slot_name + "/" + "preview.png"
	
	# remove any stale references
	#new_save.clean_cached_scenes()
	#world_save.clean_cached_scenes()
	
	# transfer all cached scenes from current save to new save
	for scene in world_save.cached_scenes:
		new_save.cache_scene(scene)
	
	# setup new save with pertinent info
	new_save.cache_scene(world.get_node(current_scene_name))
	new_save.current_scene = current_scene_name
	new_save.save_world(world)
	new_save.save_transient_entities(world.get_node("TranientEntities"))
	
	world_save = new_save

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
	var player = world.get_tree().get_nodes_in_group("player")[0]
	var current_scene = world.get_node(current_scene_name)
	#world.get_node("TranientEntities/Player").remove_child(player)
	
	#world_save.clean_cached_scenes()
	new_scene = world_save.fetch_scene(new_scene_path)
	world_save.cache_scene(current_scene)
	if new_scene.name == current_scene.name:
		new_scene = current_scene

	# Do scene switch
	#world.remove_child(current_scene)
	#TODO check if already in scene tree
	var add_to_tree = true
	for node in world.get_children():
		if new_scene.name == node.name:
			add_to_tree = false
	if add_to_tree:
		world.add_child(new_scene)
	
	#current_scene.hide()
	
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
	

	#player.position = Vector2(0.0, 0.0)
	current_scene_name = new_scene.name
	current_scene.remove_child(player)
	new_scene.add_child(player)
	player.global_position = player_start_node.global_position
	current_scene.hide()	
	new_scene.show()
	#player.position = Vector2(0,0)
	#world.get_node("TranientEntities").add_child(player)
	
func get_preview_path():
	return world_save.save_slot_preview_path
	
func save_node(node, save_file_path):
	print("saving " + str(node.name) + " node...")
	set_children_owned(node)
	var scene_pack = PackedScene.new()
	scene_pack.pack(node)
	ResourceSaver.save(save_file_path, scene_pack)
	
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
	
func get_ui_canvas():
	return world.get_node("UI")
