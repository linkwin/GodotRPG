extends YSort

export var world_save_state :Resource= load("res://Resource/WorldSaveState.tres")

export var enable_loading = true

func _ready():
	FuncLib.set_children_owned(self)
	if (enable_loading):
		#get_node("/root/FuncLib").load_world(world_save_state.get_world_save())
		get_node("/root/FuncLib").load_saved_scene()
		#get_node("/root/FuncLib").load_world_nodes(world_save_state.world_nodes_save)

func _input(event):
	if (event.is_action_pressed("save")):
		get_node("/root/FuncLib").save_node(self)
		#world_save_state.save_world(self)
	if (event.is_action_pressed("interact1")):
		var node = load("res://Scene/Placeable/Placeable.tscn").instance()
		add_child(node)
		get_node("/root/FuncLib").set_children_owned(self)
