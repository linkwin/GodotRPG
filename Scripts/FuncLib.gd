extends Node
var save_file = "res://db/savedscene.tscn"


var current_scene_name = "LocalEntities"

var cached_scenes = []

onready var world = get_tree().get_root().get_node("World")

func switch_scene(new_scene_path, door_name, target_door_name):
	var new_scene = null
	var player = world.get_node("TranientEntities/Player")
	var current_scene = world.get_node(current_scene_name)
	world.get_node("TranientEntities/Player").remove_child(player)
	
	# Fetch cached scene
	for scene in cached_scenes:
		if new_scene_path.ends_with(scene.name + ".tscn"):
			print("Fetching cached scene: " + str(scene) + "\n")
			new_scene = scene
	# Cache scene if not cached
	if (!cached_scenes.has(current_scene)):
		cached_scenes.append(current_scene)
	# Load scene from disk if not cached
	if new_scene == null:
		print("Loading scene: " + str(new_scene_path) + "\n")
		new_scene = load(new_scene_path).instance()

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
	
func load_saved_scene():
	var scene_instance = load(save_file).instance()
	get_tree().get_root().remove_child(world)
	get_tree().get_root().add_child(scene_instance)
	#world.remove_child(world.get_node(scene_instance.name))
	#world.get_node(scene_instance.name).queue_free()
	#world.add_child(load(save_file).instance())
	
func load_world_nodes(world_nodes_save):
	if (world_nodes_save != null):
		print("loading saved world...")
		var root = get_tree().get_root()
		for node in world.get_children():
			world.remove_child(node)
		for node in world_nodes_save:
			print(node)
			world.add_child(node.instance())
		#root.remove_child(world)
		#world.queue_free()
		#root.add_child(world_save_instance)
		world = get_tree().get_root().get_node("World")
	
func load_world(world_save):
	if (world_save != null):
		print("loading saved world...")
		var world_save_instance = world_save.instance()
		var root = get_tree().get_root()
		for node in world.get_children():
			world.remove_child(node)
		for node in world_save_instance.get_children():
			print(node)
			world.add_child(node)
		#root.remove_child(world)
		#world.queue_free()
		#root.add_child(world_save_instance)
		world = get_tree().get_root().get_node("World")

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
