extends Node

func _ready():
	get_node("/root/FuncLib").set_children_owned(self)

