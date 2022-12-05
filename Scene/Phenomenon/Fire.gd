extends KinematicBody2D


onready var animationplayer = $AnimationPlayer
onready var animationtree = $AnimationTree
onready var animationstate = animationtree.get("parameters/playback")

func _physics_process(delta):
	animationstate.travel("Stationary")
	
	
