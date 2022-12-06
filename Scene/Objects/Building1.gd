extends YSort

signal scenechange_to_building1


func _on_Door_body_entered(body):
	print("almost got it")
	emit_signal("scenechange_to_building1")




