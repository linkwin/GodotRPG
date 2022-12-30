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

func int_rand_range(a, b):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return(rng.randi_range(a, b))

			
func drops(item_name, min_num_drops, max_num_drops, min_dist=10, max_dist=40):
	var drop_num = int_rand_range(min_num_drops, max_num_drops)
	for i in range(drop_num):
		var pos_x = int_rand_range(min_dist, max_dist)
		var pos_y = int_rand_range(min_dist, max_dist)
		var single_item = load("res://Scene/Items/Items.tscn").instance()
		single_item.itemname = item_name
		self.add_child(single_item)
		single_item.position = Vector2(pow(-1,pos_x)*pos_x, pow(-1,pos_y)*pos_y)


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
		drops("Coal", 2, 6)
		state = "Burnt"
