extends Resource
class_name Space2D

export(bool) var active = true setget set_active
export(float) var gravity = 98.0 setget set_gravity
export(Vector2) var gravity_vector = Vector2(0,1) setget set_gravity_vector
export(float) var linear_damp = 0.1 setget set_linear_damp
export(float) var angular_damp = 1.0 setget set_angular_damp

var space : RID = RID()
var direct_space_state : Physics2DDirectSpaceState setget ,get_direct_space_state

func set_active(_active:bool):
	active = _active
	Physics2DServer.space_set_active(space,_active)
func set_gravity(_gravity:float):
	gravity = _gravity
	Physics2DServer.area_set_param(space, Physics2DServer.AREA_PARAM_GRAVITY, _gravity)
func set_gravity_vector(_gravity_vector:Vector2):
	gravity_vector = _gravity_vector
	Physics2DServer.area_set_param(space, Physics2DServer.AREA_PARAM_GRAVITY_VECTOR, _gravity_vector)
func set_linear_damp(_linear_damp:float):
	linear_damp = _linear_damp
	Physics2DServer.area_set_param(space, Physics2DServer.AREA_PARAM_LINEAR_DAMP, _linear_damp)
func set_angular_damp(_angular_damp:float):
	angular_damp = _angular_damp
	Physics2DServer.area_set_param(space, Physics2DServer.AREA_PARAM_ANGULAR_DAMP, _angular_damp)
	
func get_direct_space_state():
	return Physics2DServer.space_get_direct_state(space)
	

	
func _init():
	space = Physics2DServer.space_create()
	set_active(active)
	set_gravity(gravity)
	set_gravity_vector(gravity_vector)
	set_linear_damp(linear_damp)
	set_angular_damp(angular_damp)
