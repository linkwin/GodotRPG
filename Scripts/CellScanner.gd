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
		#var scene = load(grid.grid_dict[i].get_path())
		var scene_instance = grid.grid_dict[i].instance()
		scene_instance.name += "(1)"
		scene_instance.connect("placeable_moved", self, "_on_Area2D_placeable_moved")
		scene_instance.connect("placeable_placed", self, "_on_Area2D_placeable_placed")
		scene_instance.position = grid.calculate_world_position(i)
		get_tree().get_current_scene().get_node("YSort").add_child(scene_instance)

func check_cell(cell_position):
	# Shape Cast
	self.position = grid.calculate_world_position(cell_position)
	physics_query.transform = self.transform
	var space_state = get_world_2d().direct_space_state
	var hits = space_state.intersect_shape(physics_query)
	
	# Get scene instance to send for saving
	var scene_instance = get_tree().get_current_scene().get_node("YSort").get_node(hits[0].collider.name)

	grid.save_cell(cell_position, scene_instance)
	
	#debug
	print("Number of objects hit: " + str(hits.size()))
	print(hits)

func _on_Area2D_placeable_moved(from):
	grid.grid_dict.erase(from)

func _on_Area2D_placeable_placed(to):
	check_cell(to)
