extends KinematicBody2D

signal spawninstance(scene_instance)
const speed = 140
var vel = Vector2.ZERO
const acc = 1000
const friction = 2000
onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree 
onready var animationstate = animationtree.get("parameters/playback")
var hasfire = false
var magicstate = "Fire"

var dir = Vector2(0,1)

var health = 100
var magic = 100
var magic_use_rate = 0.005
var magic_count = 0


func _physics_process(delta):
	var input_vec = Vector2.ZERO
	magic -= 5*magic_use_rate*sqrt(magic_count)
	if magic_count == 0 :
		magic = min(magic+20*magic_use_rate, 100)
	print(magic_count)
	input_vec.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_vec.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	input_vec = input_vec.normalized()
	
	if input_vec != Vector2.ZERO and health > 0:
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
	
	
	
	if magicstate == "Fire" and health > 0:
		if Input.get_action_strength("interact2")> 0 and magic > 1:
			print(delta)
			var fire = load("res://Scene/Phenomenon/Fire.tscn").instance()
			get_tree().get_root().get_node("World/TranientEntities").add_child(fire)
			magic_count += 1
			fire.position = dir*30 +  position
			fire.player_made = true
		
		if not hasfire and Input.get_action_strength("interact3")> 0 and magic > 1:
			var firebreath = load("res://Scene/Phenomenon/Fire.tscn").instance()
			hasfire = true
			magic_count += 1
			firebreath.player_made = true
			get_tree().get_root().get_node("World/TranientEntities/Player/mouth").add_child(firebreath)
			firebreath.rotation_degrees = 360*atan2(dir.y,dir.x)/(2*PI)+180
			
	





func _on_Area2D_body_entered(body):
	var bodytype = body.name
	if bodytype.get_slice("@", 1) == "Fire":
		if body.home != self:
			health -= 0.5
