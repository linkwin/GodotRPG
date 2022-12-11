
extends KinematicBody2D

var entityprops = [4]


onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")
onready var home = get_parent().get_parent()
var state = "Alive" 
var player_made = false

const speed = 700
var vel = Vector2.ZERO
const acc = 1500
const friction = 800



func _physics_process(delta):
	if player_made:
		var player = get_tree().get_root().get_node("World/TranientEntities/Player")
		if home.name == "World":
			var input_vec = Vector2.ZERO
			if Input.get_action_strength("interact1") != 0:
				input_vec = (get_global_mouse_position() - home.position) - position
			if Input.get_action_strength("interact1") == 0:
				input_vec = Vector2.ZERO
			input_vec = input_vec.normalized()
			var err1 = 0.1*(2*randf()-1)
			var err2 = 0.1*(2*randf()-1)
			vel = vel + Vector2(err1,err2)
			
			if input_vec != Vector2.ZERO:
				vel = vel.move_toward(speed*input_vec,delta*acc)
				"""look_at(-input_vec) """
				var veldir = vel.normalized()
				rotation_degrees = 360*atan2(veldir.y,veldir.x)/(2*PI)+180
			else:
				vel = vel.move_toward(Vector2.ZERO, friction*delta)
			
			if vel.length() > 400:
				animationstate.travel("Spraying")
				animationstate.travel("Spray")
			if 400 >= vel.length() and vel.length() > 10:
				animationstate.travel("Moving")
			if vel.length() < 10:
				animationstate.travel("Stationary")
			
			move_and_slide(vel)
			
			var timer
			
			if vel.length() < 0.1 and Input.get_action_strength("interact1") == 0:
				animationstate.travel("Decay")
				timer = Timer.new()
				timer.connect("timeout",self,"do_this")
				timer.wait_time = 1
				timer.one_shot = true
				add_child(timer)
				timer.start()
			
		if home.name == "Player":
			animationstate.travel("SprayStrt")
			animationstate.travel("Spray")
			rotation_degrees = 360*atan2(home.dir.y,home.dir.x)/(2*PI)
			position = home.dir.normalized()*20
			collision_mask = 0
			
			var timer
			
			if Input.get_action_strength("interact3") == 0:
				animationstate.travel("Decay")
				timer = Timer.new()
				timer.connect("timeout",self,"do_this")
				timer.wait_time = 1
				timer.one_shot = true
				add_child(timer)
				timer.start()

func do_this():
	if player_made == true:
		var player = get_tree().get_root().get_node("World/TranientEntities/Player")
		if home.name == "World":
				player.magic_count = max(player.magic_count-1, 0)
		if home.name == "Player":
			home.hasfire = false
			home.magic_count = max(home.magic_count-1, 0)
	if vel.length() < 0.1:
		self.get_parent().remove_child(self)
		self.queue_free()

		
	
		
