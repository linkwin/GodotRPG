extends Node

func _ready():
	$Door.connect("body_entered", get_parent(), "_on_Door_body_entered")
