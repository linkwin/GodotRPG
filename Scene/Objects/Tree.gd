extends KinematicBody2D

var state = "Live"

onready var LiveTree 	=  $Tree1
onready var BurntTree 	=  $BurntTree1
onready var BurningTree =  $BurningTree

var timer = Timer.new()

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
	

func _on_Interaction_Base_body_entered(body):
	print(body.name)
	var bodytype = body.name
	if bodytype.get_slice("@", 1) == "Fire":
		state = "Burning"


func _ready():
	if state == "Live":
		timer.connect("timeout",self,"do_this")
		timer.wait_time = 10
		timer.one_shot = true
		add_child(timer)
		timer.start()

func do_this():
	state = "Burnt"

