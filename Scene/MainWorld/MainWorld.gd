extends YSort

export var world_save_state :Resource= load("res://Resource/WorldSaveState.tres")

export var enable_loading = true

func _ready():
	FuncLib.set_children_owned(self)
	if (enable_loading):
#		FuncLib.load_world_save_state()
		world_save_state.load_all_saved_scenes()
		load_entities()
		
func load_entities():
	remove_child($LocalEntities)
	add_child(world_save_state.fetch_scene("res://Scene/MainWorld/LocalEntities.tscn"))

func _input(event):
	if (event.is_action_pressed("save")):
		world_save_state.save_world(self)
	if (event.is_action_pressed("interact1")):
		var node = load("res://Scene/Placeable/Placeable.tscn").instance()
		$LocalEntities.add_child(node)
		FuncLib.set_children_owned($LocalEntities)
