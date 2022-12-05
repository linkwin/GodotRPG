extends Node2D


onready var _animated_spriter = $FireR/RightFlame
onready var _animated_spritel = $FireL/LeftFlame
onready var _animated_spriteu = $FireU/UpFlame
onready var _animated_sprited = $FireD/DownFlame


var direction : Vector2 = Vector2()


func _process(delta):
	
	if direction == Vector2(0, -1):
		_animated_spriteu.play("UpFlame")
	if direction == Vector2(0, 1):
		_animated_sprited.play("DownFlame")
	if direction == Vector2(-1, 0):
		_animated_spritel.play("LeftFlame")
	if direction == Vector2(1, 0):
		_animated_spriter.play("RightFlame")
	

