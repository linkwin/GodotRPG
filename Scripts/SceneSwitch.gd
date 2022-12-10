extends Node

func _on_door_entered(target_scene_ref, door_name, target_door_name):
	FuncLib.switch_scene(target_scene_ref, door_name, target_door_name)
