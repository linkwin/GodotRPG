extends YSort



func _on_OutDoor1_body_entered(body):
	var localent = preload("res://Scene/MainWorld/LocalEntities.tscn").instance()
	var world =  get_tree().get_root().get_node("World")
	var player = get_tree().get_root().get_node("World/TranientEntities/Player")
	var house1 =  get_tree().get_root().get_node("World/House1")
	player.position = Vector2(400,-30)
	world.remove_child(house1)
	world.add_child(localent)

