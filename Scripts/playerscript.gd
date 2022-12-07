extends KinematicBody2D

signal spawninstance(scene_instance)
const speed = 140
var vel = Vector2.ZERO
const acc = 1000
const friction = 2000
onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree 
onready var animationstate = animationtree.get("parameters/playback")


var dir = Vector2(0,1)

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	input_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vec.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO:
		vel = vel.move_toward(speed*input_vec,delta*acc)
		dir = input_vec*(1/max(abs(input_vec.x),abs(input_vec.y)))
		animationtree.set("parameters/Idle/blend_position",dir)
		animationtree.set("parameters/Run/blend_position",dir)
		animationstate.travel("Run")
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
		animationstate.travel("Idle")
		
# warning-ignore:return_value_discarded
	move_and_slide(vel)
	
	if Input.get_action_strength("interact2")> 0:
		var fire = load("res://Scene/Phenomenon/Fire.tscn").instance()
		fire.position = dir*60
		get_tree().get_root().get_node("World/TranientEntities").add_child(fire)
		#get_tree().get_root().get_node("/root/YSort").add_child(fire)
		#emit_signal("spawninstance", fire)
		print(dir)
	print(position)





