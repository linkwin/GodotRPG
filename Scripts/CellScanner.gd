extends Area2D

export var grid :Resource= preload("res://Scene/Grid/DefaultGrid.tres")

var physics_query

func _ready():
	physics_query = Physics2DShapeQueryParameters.new()
	physics_query.exclude = [self, $CollisionShape2D]
	physics_query.set_shape($CollisionShape2D.shape)

func check_cell(cell_position):
	var physics := get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	query.shape_rid = $CollisionShape2D.get_rid()
	query.transform = global_transform
	var results = physics.intersect_shape(query)
	print(results)
	
	self.position = grid.calculate_world_position(cell_position)
	print("check cell pos:" + str(self.position))
	var space_state = get_world_2d().direct_space_state
	var hits = space_state.intersect_shape(physics_query)
	print(hits.size())
	#grid.grid_dict[cell_position] = hits


func _on_Area2D_placeable_moved(from):
	grid.grid_dict.erase(from)


func _on_Area2D_placeable_placed(to):
	check_cell(to)
