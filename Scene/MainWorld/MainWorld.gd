extends YSort

export var world_save_state :Resource= load("res://Resource/WorldSaves/WorldSaveState.tres")

onready var an_item = item
export var enable_loading = true

func _ready():
	FuncLib.set_children_owned(self)
#	if (enable_loading):
##		FuncLib.load_world_save_state()
#
#		load_entities()

		
func load_entities(prev_save):
	world_save_state.load_all_saved_scenes()
	#remove_child($LocalEntities)
	var local_entities = get_node(FuncLib.current_scene_name)
	local_entities.name = "pending_delete"
	remove_child(local_entities)
	prev_save.destroy_cached_scene(local_entities)
	local_entities.queue_free()
	add_child(world_save_state.fetch_scene("res://Scene/MainWorld/" + 
		str(world_save_state.current_scene) + ".tscn"))
	remove_child($TranientEntities)
	add_child(world_save_state.load_transient_entities())
	FuncLib.current_scene_name = world_save_state.current_scene

func _input(event):
#	if (event.is_action_pressed("save")):
#		world_save_state.save_world(self)
#		world_save_state.save_transient_entities($TranientEntities)
	if (event.is_action_pressed("interact1")):
		var node = load("res://Scene/Placeable/Placeable.tscn").instance()
		node.icon_path = "res://Assets/ItemIcons/bench.png"
		$LocalEntities.add_child(node)
		FuncLib.set_children_owned($LocalEntities)
	
