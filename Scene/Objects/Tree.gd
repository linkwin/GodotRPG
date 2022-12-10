extends KinematicBody2D

var state = "Live"

onready var LiveTree 	=  $Tree1
onready var BurntTree 	=  $BurntTree1
onready var BurningTree =  $BurningTree

func _get_property_list():
	return [
		{
			"name": state,
			"type": TYPE_STRING,
			"usage": PROPERTY_USAGE_STORAGE
		}
	]

func _process(delta):
	if state == "Live":
		LiveTree.show()
		BurntTree.hide()
		BurningTree.hide()
	if state == "Burnt":
		LiveTree.hide()
		BurntTree.show()
		BurningTree.hide()
	if state == "Burning":
		LiveTree.hide()
		BurntTree.hide()
		BurningTree.show()
	
var timer

func _on_Interaction_Base_body_entered(body):
	var bodytype = body.name
	if state == "Live":
		if bodytype.get_slice("@", 1) == "Fire":
			state = "Burning"
			timer = Timer.new()
		if state == "Burning":
			timer.connect("timeout",self,"do_this")
			timer.wait_time = 5
			timer.one_shot = true
			add_child(timer)
			timer.start()

func do_this():
	if state == "Burning":
		state = "Burnt"
