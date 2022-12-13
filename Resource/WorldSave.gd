extends Resource
class_name WorldSave

export(PackedScene) var world_state
export(String, FILE) var world_state_save_path = "res://db/WorldSaveState.tscn"

export(Array) var world_nodes_save
export var save_path = "res://Resource/WorldSaveState.tres"

export var transient_entities_save_path = "res://db/TransientEntities.tscn"

export var current_scene = "LocalEntities"

var world_entities = []

var cached_scenes = []

func save_transient_entities(scene):
	var packed_scene = PackedScene.new()
	packed_scene.pack(scene)
	ResourceSaver.save(transient_entities_save_path, packed_scene)
	
func load_transient_entities():
	return load(transient_entities_save_path).instance()

func get_world_state_instance():
	return load(world_state_save_path).instance()

func save_world(world_scene):
	print("Saving world...")
	world_nodes_save = []
	FuncLib.cache_current_scene()
	
	var world_save = PackedScene.new()
	world_save.pack(world_scene)
	world_state = world_save
	ResourceSaver.save(world_state_save_path, world_save)
	
	for node in cached_scenes:
		var scene_pack = PackedScene.new()
		scene_pack.pack(node)
		var path = "res://db/" + str(node.name) + ".tscn"
		if (not path in world_nodes_save):
			world_nodes_save.append(path)
		ResourceSaver.save(path, scene_pack)
	
	ResourceSaver.save(save_path, self)
	
func cache_scene(current_scene):
	# Cache scene if not cached
	print("Caching scene: " + str(current_scene.name))
	var found = false
	for scene in cached_scenes:
		if scene.name == current_scene.name:
			found = true
	if (!found):
		cached_scenes.append(current_scene)
		
func destroy_cached_scene(scene):
	cached_scenes.erase(scene)
		
func load_all_saved_scenes():
	for scene in world_nodes_save:
		cached_scenes.append(load(scene).instance())
		
func fetch_scene(new_scene_path):
	var new_scene = null
	# Fetch cached scene
	for scene in cached_scenes:
		if new_scene_path.ends_with(scene.name + ".tscn"):
			print("Fetching cached scene: " + str(scene))
			new_scene = scene

	# Load scene from disk if not cached
	if new_scene == null:
		print("Loading scene: " + str(new_scene_path))
		new_scene = load(new_scene_path).instance()
	return new_scene
