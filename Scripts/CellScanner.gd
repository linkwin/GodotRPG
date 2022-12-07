extends Area2D

export var grid :Resource= load("res://Scene/Grid/DefaultGrid.tres")

var physics_query

func _ready():
	physics_query = Physics2DShapeQueryParameters.new()
	physics_query.exclude = [self, $CollisionShape2D]
	physics_query.set_shape($CollisionShape2D.shape)
	physics_query.collide_with_areas = true
	physics_query.collide_with_bodies = true
	physics_query.collision_layer = self.collision_layer
	load_all_cells()
	
func load_all_cells():
	print(str(grid.grid_dict.size()) + " cells to load!")
	for i in grid.grid_dict:
		var scene = load(grid.grid_dict[i])
	#	get_tree().get_current_scene().get_node("YSort").add_child(scene.instance())

func check_cell(cell_position):
	self.position = grid.calculate_world_position(cell_position)
	physics_query.transform = self.transform
	var space_state = get_world_2d().direct_space_state
	var hits = space_state.intersect_shape(physics_query)
	
	var scene = PackedScene.new()
	scene.pack(get_tree().get_current_scene().get_node("YSort").get_node(self.name))
	ResourceSaver.save("res://db/savedscene.tscn", scene)
	#get_tree().get_current_scene().get_node("YSort").add_child(scene.instance())
	grid.save_cell(cell_position, "res://db/savedscene.tscn")
	#print("Number of objects hit: " + str(hits.size()))
	#print(hits[0])

func _on_Area2D_placeable_moved(from):
	grid.grid_dict.erase(from)

func _on_Area2D_placeable_placed(to):
	check_cell(to)
