extends Area2D

export var grid :Resource= preload("res://Scene/Grid/DefaultGrid.tres")

var physics_query

var should_check_cell = false

func _ready():
	physics_query = Physics2DShapeQueryParameters.new()
	physics_query.exclude = [self, $CollisionShape2D]
	physics_query.set_shape($CollisionShape2D.shape)
	physics_query.collide_with_areas = true
	physics_query.collide_with_bodies = true
	physics_query.collision_layer = 0b11111110

func check_cell(cell_position):
	self.position = grid.calculate_world_position(cell_position)
	should_check_cell = true
	physics_query.transform = self.transform
	var space_state = get_world_2d().direct_space_state
	var hits = space_state.intersect_shape(physics_query)
	print(hits.size())
	should_check_cell = false;
	

func _on_Area2D_placeable_moved(from):
	grid.grid_dict.erase(from)


func _on_Area2D_placeable_placed(to):
	check_cell(to)
