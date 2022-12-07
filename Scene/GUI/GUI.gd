extends Node

onready var func_lib = get_node("/root/FuncLib")

func _input(event):
	if (event.is_action_pressed("one")):
		func_lib.show_one_child($".", $one)
	if (event.is_action_pressed("two")):
		func_lib.show_one_child($".", $two)
	if (event.is_action_pressed("three")):
		func_lib.show_one_child($".", $three)
	if (event.is_action_pressed("pause")):
		func_lib.hide_all_children($".")
