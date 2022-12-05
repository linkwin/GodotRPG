extends Area2D

var grid :Grid= preload("res://Scene/Grid/DefaultGrid.tres")
var last_mouse_position := get_global_mouse_position()
var selected = false

func _process(delta):
	if Input.is_mouse_button_pressed(1) and selected:
		last_mouse_position = get_global_mouse_position()
		self.position = get_global_mouse_position()
	elif selected:
		print(get_global_mouse_position())
		var grid_coordinates = grid.calculate_grid_coordinates(last_mouse_position)
		self.position = grid.calculate_world_position(grid_coordinates)
		print(position)
		selected = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		selected = true
