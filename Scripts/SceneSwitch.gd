extends Node

export var scene_ref := ""

func _on_Door_body_entered(body):
	get_node("/root/FuncLib").switch_scene(scene_ref)
