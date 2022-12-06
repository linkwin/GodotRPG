extends Resource
class_name Grid

export var grid_size := Vector2(50, 50)

export var cell_size := Vector2(64, 64)

var grid_dict = {}

var _half_cell_size = cell_size / 2

func snap_to_grid(world_position: Vector2) -> Vector2:
	var cell_x = stepify(world_position.x, cell_size.x)
	var cell_y = stepify(world_position.y, cell_size.y)
	
	return Vector2(cell_x, cell_y)
	

func save_cell(cell_coordinates: Vector2, node):
	grid_dict[cell_coordinates] = node

func calculate_world_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size
	
func calculate_grid_coordinates(world_position: Vector2) -> Vector2:
	var cell_x = stepify(world_position.x, cell_size.x)
	var cell_y = stepify(world_position.y, cell_size.y)

	return Vector2(cell_x / cell_size.x, cell_y / cell_size.y)	
	
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < grid_size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < grid_size.y

func clamp_grid_position(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, grid_size.x - 1.0)
	out.y = clamp(out.y, 0, grid_size.y - 1.0)
	return out
