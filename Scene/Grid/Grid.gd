extends Resource
class_name Grid

export var cell_size := Vector2(64, 64)

export var grid_dict = {} #Dictonary for saving object locations {cell_coordinate: Vector2 => saved_scene: PackedScene}

var _half_cell_size = cell_size / 2

func save_cell(cell_coordinates: Vector2, scene):
	#TODO some checking, if key exists already?
	if (scene != null):
		grid_dict[cell_coordinates] = scene
		ResourceSaver.save("res://Scene/Grid/DefaultGrid.tres", self)
	else:
		print("Scene is null!!")

func snap_to_grid(world_position: Vector2) -> Vector2:
	var cell_x = stepify(world_position.x, cell_size.x)
	var cell_y = stepify(world_position.y, cell_size.y)
	
	return Vector2(cell_x, cell_y)

func calculate_world_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size
	
func calculate_grid_coordinates(world_position: Vector2) -> Vector2:
	var cell_x = stepify(world_position.x, cell_size.x)
	var cell_y = stepify(world_position.y, cell_size.y)

	return Vector2(cell_x / cell_size.x, cell_y / cell_size.y)
	
