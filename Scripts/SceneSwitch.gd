extends Node

export var scene_ref := ""

export onready var player_spawn_loc := get_node("PlayerStart")

func _on_Door_body_entered(body):
	var new_scene = load(scene_ref).instance()
	var world =  get_tree().get_root().get_node("World")
	var player = world.get_node("TranientEntities/Player")
	var current_scene =  world.get_node(self.name)

	world.remove_child(current_scene)
	world.add_child(new_scene)
	player.position = world.get_node(new_scene.name + "/PlayerStart").position
