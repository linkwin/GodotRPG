tool
extends Node2D

export(String, FILE) var target_scene_ref

export var target_door_name = ""

signal door_entered(target_scene_ref, door_name, target_door_name)

func _enter_tree():
	self.get_node("PlayerStart").prev_scene = target_scene_ref.get_file().trim_suffix(".tscn")
	self.get_node("PlayerStart").door_name = self.name
	self.get_node("PlayerStart").target_door_name = self.target_door_name

func _on_Door_body_entered(body):
	emit_signal("door_entered", target_scene_ref, self.name, target_door_name)
