extends YSort


func _ready():
	get_node("/root/FuncLib").set_children_owned(self)

func _on_Player_spawninstance(scene_instance):
	add_child(scene_instance)


func _on_Building1_scenechange_to_building1():
	pass # Replace with function body.
