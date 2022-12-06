
extends KinematicBody2D

var entityprops = [4]


onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")


const speed = 140
var vel = Vector2.ZERO
const acc = 1000
const friction = 2000


func _physics_process(delta):
	var input_vec = Vector2.ZERO
	if Input.get_action_strength("interact1") != 0:
		input_vec = get_global_mouse_position()
	if Input.get_action_strength("interact1") == 0:
		input_vec = Vector2.ZERO
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO:
		vel = vel.move_toward(speed*input_vec,delta*acc)
		look_at(-get_global_mouse_position()) 
		animationstate.travel("Moving")
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
		animationstate.travel("Stationary")
		
	move_and_slide(vel)
	
