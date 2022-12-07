extends YSort



func _on_Door_body_entered(body):
	var house1 = load("res://Scene/Objects/House1.tscn").instance()
	var world =  get_tree().get_root().get_node("World")
	var player = get_tree().get_root().get_node("World/TranientEntities/Player")
	var localent =  get_tree().get_root().get_node("World/LocalEntities")
	player.position = Vector2.ZERO
	world.remove_child(localent)
	world.add_child(house1)
	


