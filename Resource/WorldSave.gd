extends Resource
class_name WorldSave

export(Array) var world_nodes_save
export var save_path = "res://Resource/WorldSaveState.tres"

var world_entities = []

func save_world(world_scene):
	print("Attempting to save world")
	world_nodes_save = []

	for node in world_scene.get_children():
		var scene_pack = PackedScene.new()
		scene_pack.pack(node)
		var path = "res://db/" + str(node.name) + ".tscn"
		world_nodes_save.append(path)
		ResourceSaver.save(path, scene_pack)
	
	ResourceSaver.save(save_path, self)
	
