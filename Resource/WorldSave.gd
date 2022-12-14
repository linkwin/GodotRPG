extends Resource
class_name WorldSave

export(Array) var world_nodes_save

export var save_slot_preview_path = ""

export var save_slot_name = "WorldSaveState"

export(Dictionary) var date_time = Time.get_datetime_dict_from_system()

var save_path = "res://Resource/WorldSaves/" + save_slot_name + ".tres"

var transient_entities_save_path = "res://db/" + save_slot_name + "/TransientEntities.tscn"

export var current_scene = "LocalEntities"

var world_entities = []

var cached_scenes = []

func save_transient_entities(scene):
	var packed_scene = PackedScene.new()
	packed_scene.pack(scene)
	ResourceSaver.save(transient_entities_save_path, packed_scene)
	
func load_transient_entities():
	transient_entities_save_path = "res://db/" + save_slot_name + "/TransientEntities.tscn"
	return load(transient_entities_save_path).instance()

func save_world(world_scene):
	save_path = "res://Resource/WorldSaves/" + save_slot_name + ".tres"

	transient_entities_save_path = "res://db/" + save_slot_name + "/TransientEntities.tscn"
	
	print("Saving world...")
	date_time = Time.get_datetime_dict_from_system()
	world_nodes_save = []
	FuncLib.cache_current_scene()
	
	for node in cached_scenes:
		var scene_pack = PackedScene.new()
		scene_pack.pack(node)
		var path = "res://db/" + save_slot_name + "/" + str(node.name) + ".tscn"
		if (not path in world_nodes_save):
			world_nodes_save.append(path)
		ResourceSaver.save(path, scene_pack)
	
	ResourceSaver.save(save_path, self)
	
func cache_scene(current_scene_ref):
	# Cache scene if not cached
	#print("Caching scene: " + str(current_scene.name))
	var found = false
	for scene in cached_scenes:
		if is_instance_valid(scene):
			if scene.name == current_scene_ref.name:
				found = true
		else:
			cached_scenes.erase(scene)
	if (!found):
		cached_scenes.append(current_scene_ref)
		
func clean_cached_scenes():
	for scene in cached_scenes:
		if !is_instance_valid(scene):
			cached_scenes.erase(scene)
		
func destroy_cached_scene(scene):
	cached_scenes.erase(scene)
		
func load_all_saved_scenes():
	for scene in world_nodes_save:
		cached_scenes.append(load(scene).instance())
		
func fetch_scene(new_scene_path):
	var new_scene = null
	# Fetch cached scene
	for scene in cached_scenes:
		if is_instance_valid(scene):
			if new_scene_path.ends_with(scene.name + ".tscn"):
				print("Fetching cached scene: " + str(scene))
				new_scene = scene
		else:
			cached_scenes.erase(scene)

	# Load scene from disk if not cached
	if new_scene == null:
		print("Loading scene: " + str(new_scene_path))
		new_scene = load(new_scene_path).instance()
	return new_scene
