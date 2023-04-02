extends Node2D
class_name SubSpace2D

export(Resource) var space2D = preload("res://Scripts/SubSpace/SubSpaceTemplate.tres") setget, get_space2D

func get_space2D():
	return space2D as Space2D
	
func _update_space(node:Node):
	if node is CollisionObject2D:
		print(node.name)
		if node is Area2D:
			Physics2DServer.area_set_space(node.get_rid(),space2D.space)
		else:
			Physics2DServer.body_set_space(node.get_rid(),space2D.space)
	for child in node.get_children():
		_update_space(child)

func _ready():
	space2D = space2D.duplicate()
	_update_space(self)

func _enter_tree():
	get_tree().connect("node_added",self,"_node_added")
func _exit_tree():
	get_tree().disconnect("node_added",self,"_node_added")

func _node_added(node:Node):
	if is_a_parent_of(node) and node is CollisionObject2D:
		if node is Area2D:
			Physics2DServer.area_set_space(node.get_rid(),space2D.space)
		else:
			Physics2DServer.body_set_space(node.get_rid(),space2D.space)

func _on_door_entered(target_scene_ref, door_name, target_door_name):
	FuncLib.switch_scene(target_scene_ref, door_name, target_door_name)
