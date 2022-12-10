extends Area2D

signal placeable_moved(from)
signal placeable_placed(to)

export onready var grid :Resource= load("res://Scene/Grid/DefaultGrid.tres")
var last_mouse_position := get_global_mouse_position()
var selected = false

onready var prev_pos = self.position

func _ready():
	FuncLib.set_children_owned(self)

func _process(delta):
	if Input.is_mouse_button_pressed(1) and selected:
		last_mouse_position = get_global_mouse_position()
		self.position = grid.snap_to_grid(last_mouse_position)
		if (self.position != prev_pos):
			emit_signal("placeable_moved", grid.calculate_grid_coordinates(self.position))
			prev_pos = self.position
			print(position)
	elif selected:
		print(get_global_mouse_position())
#		var grid_coordinates = grid.calculate_grid_coordinates(last_mouse_position)
#		self.position = grid.calculate_world_position(grid_coordinates)
		self.position = grid.snap_to_grid(last_mouse_position)
		emit_signal("placeable_placed", grid.calculate_grid_coordinates(self.position))
		print(position)
		selected = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("placeable_moved", grid.calculate_grid_coordinates(self.position))
		selected = true
