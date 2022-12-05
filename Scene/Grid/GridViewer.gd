extends Node

#export var grid: Resource = preload("res://Scene/Grid/Grid.tres")

export var cell_scene = preload("res://Scene/Phenomenon/Fire.tscn")

func _ready():
	var grid = load("res://Scene/Grid/DefaultGrid.tres") as Grid
	print(ResourceLoader.exists("res://Scene/Grid/Grid.tres"))
	for x in grid.grid_size.x:
		for y in grid.grid_size.y:
			var spawn = cell_scene.instance()
			spawn.position = grid.calculate_world_position(Vector2(x,y))
			add_child(spawn)
