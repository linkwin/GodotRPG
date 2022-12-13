extends Node

onready var func_lib = get_node("/root/FuncLib")
onready var home = get_parent().get_parent()
onready var health_gauge = $HBoxContainer/Bars/HealthGauge
onready var magic_gauge = $HBoxContainer/Bars/MagicGauge

func _process(delta):
	health_gauge.value = home.health
	magic_gauge.value = home.magic


"""
func _input(event):
	if (event.is_action_pressed("one")):
		func_lib.show_one_child($".", $one)
	if (event.is_action_pressed("two")):
		func_lib.show_one_child($".", $two)
	if (event.is_action_pressed("three")):
		func_lib.show_one_child($".", $three)
	if (event.is_action_pressed("pause")):
		func_lib.hide_all_children($".")
"""

