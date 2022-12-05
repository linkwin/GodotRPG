extends Resource
class_name Grid

export var grid_size := Vector2(50, 50)

export var cell_size := Vector2(64, 64)

var _half_cell_size = cell_size / 2

func calculate_world_position(grid_position: Vector2) -> Vector2:
	return grid_position * cell_size
	
func calculate_grid_coordinates(world_position: Vector2) -> Vector2:
	var returnVal = Vector2()
	var flooredVector = (world_position / cell_size).floor()
	var xcoord = world_position.x / cell_size.x
	var ycoord = world_position.y / cell_size.y
	if (xcoord - flooredVector.x > _half_cell_size.x):
		returnVal.x = ceil((world_position.x / cell_size.x))
	else:
		returnVal.x = floor((world_position.x / cell_size.x))
	if (ycoord - flooredVector.y > _half_cell_size.y):
		returnVal.y = ceil((world_position.y / cell_size.y))
	else:
		returnVal.y = floor((world_position.y / cell_size.y))
	return returnVal
	
func is_within_bounds(cell_coordinates: Vector2) -> bool:
	var out := cell_coordinates.x >= 0 and cell_coordinates.x < grid_size.x
	return out and cell_coordinates.y >= 0 and cell_coordinates.y < grid_size.y

func clamp_grid_position(grid_position: Vector2) -> Vector2:
	var out := grid_position
	out.x = clamp(out.x, 0, grid_size.x - 1.0)
	out.y = clamp(out.y, 0, grid_size.y - 1.0)
	return out
