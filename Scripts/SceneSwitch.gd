extends Node

export(String, FILE) var scene_ref

func _on_Door_body_entered(body):
	FuncLib.switch_scene(scene_ref)
