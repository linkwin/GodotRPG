
extends KinematicBody2D

var entityprops = [4]


onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var home = get_parent()

const speed = 700
var vel = Vector2.ZERO
const acc = 1500
const friction = 1000

func _physics_process(delta):
	var input_vec = Vector2.ZERO
	if Input.get_action_strength("interact1") != 0:
		input_vec = (get_global_mouse_position() - home.position) - position
	if Input.get_action_strength("interact1") == 0:
		input_vec = Vector2.ZERO
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO:
		var err1 = 0.1*(2*randf()-1)
		var err2 = 0.1*(2*randf()-1)
		vel = vel.move_toward(speed*input_vec,delta*acc) + Vector2(err1,err2)
		"""look_at(-input_vec) """
		var veldir = vel.normalized()
		rotation_degrees = 360*atan2(veldir.y,veldir.x)/(2*PI)+180
		
		animationstate.travel("Moving")
	else:
		vel = vel.move_toward(Vector2.ZERO, friction*delta)
		animationstate.travel("Stationary")
		
		
	move_and_slide(vel)
	
