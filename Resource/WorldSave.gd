extends Resource
class_name WorldSave

export(PackedScene) var world_save
export(Array) var world_nodes_save

var save_file = "res://db/savedscene.tscn"

func save_world(world_scene):
	print("Attempting to save world")
	world_nodes_save = []
	var i = 0
	for node in world_scene.get_children():
		world_nodes_save.append(PackedScene.new())
		world_nodes_save[i].pack(node)
		i += 1
	world_save = PackedScene.new()
	world_save.pack(world_scene)
	
	ResourceSaver.save(save_file, world_save)
	ResourceSaver.save("res://Resource/WorldSaveState.tres", self)
	
func get_world_save() -> PackedScene:
	return world_save
