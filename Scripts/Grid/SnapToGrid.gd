extends StaticBody2D

signal placeable_moved(from)
signal placeable_placed(to)

export onready var grid :Resource= load("res://Scene/Grid/DefaultGrid.tres")
var last_mouse_position := get_global_mouse_position()
var selected = false

var overlapping_bodys = []

var last_place_pos = Vector2.ZERO

onready var prev_pos = self.position

export(String, FILE) var icon_path

var process_rotate = false

onready var sprite_node = $Sprite

func _ready():
	FuncLib.set_children_owned(self)
	sprite_node.texture = load(icon_path)

func _process(delta):
	if not overlapping_bodys.empty():
		sprite_node.self_modulate = Color(0.5,0.5,0.5,0.5)
	else:
		sprite_node.self_modulate = Color(1,1,1,1)
	
	if Input.is_mouse_button_pressed(1) and selected:
		if process_rotate:
			sprite_node.frame = (sprite_node.frame + 1) % sprite_node.vframes
			process_rotate = false
		last_mouse_position = get_global_mouse_position()
		self.position = grid.snap_to_grid(last_mouse_position)
		$Collider.disabled = true
		if (self.position != prev_pos):
			emit_signal("placeable_moved", grid.calculate_grid_coordinates(self.position))
			prev_pos = self.position
	
	elif selected:
		if overlapping_bodys.empty():
			self.position = grid.snap_to_grid(last_mouse_position)
		else:
			self.position = grid.snap_to_grid(last_place_pos)
		$Collider.disabled = false
		emit_signal("placeable_placed", grid.calculate_grid_coordinates(self.position))
		selected = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		last_place_pos = self.position
		emit_signal("placeable_moved", grid.calculate_grid_coordinates(self.position))
		selected = true
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_RIGHT:
		queue_free()

func _unhandled_input(event):
	if (event.is_action_pressed("rotate")):
		if selected:
			process_rotate = true
		

func _on_Area2D_body_entered(body):
	if body != self:
		overlapping_bodys.append(body)

func _on_Area2D_body_exited(body):
	overlapping_bodys.erase(body)
