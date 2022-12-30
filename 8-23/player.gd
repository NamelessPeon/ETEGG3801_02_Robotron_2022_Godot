class_name Player3D
extends KinematicBody

export var speed:float = 10.5
export var health = 100
export var acceleration = 70
export var friction = 60
export var air_friction = 10
export var gravity = -40
export var jump_impulse = 20
export var controller_sensitivity = 3
export var mouse_sensitivity = .1
export var rot_speed = 5
export (int, 0, 10) var push = 1

var velocity = Vector3.ZERO
var snap_vector = Vector3.ZERO

onready var spring_arm = $SpringArm

var color_change_delay = 0.1
var time_to_color_change = color_change_delay

var bullet_scene = preload("res://bullet.tscn")

#var direction_map = {"move_left": Vector3(-1,0,0),
#					"move_right": Vector3(1,0,0),
#					"move_up": Vector3(0,0,-1),
#					"move_down": Vector3(0,0,1)}

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if event.is_action_pressed("toggle_mouse_captured"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		spring_arm.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg2rad(-75), deg2rad(75))

func _physics_process(delta):
	var input_vector = get_input_vector()
	var direction = get_direction(input_vector)
	apply_movement(input_vector, direction, delta)
	apply_friction(direction, delta)
	apply_gravity(delta)
	velocity = move_and_slide_with_snap(velocity,snap_vector, Vector3.UP, true)
	
func get_input_vector():
	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return input_vector.normalized() if input_vector.length() > 1 else input_vector
	

func get_direction(input_vector):
	var direction = (input_vector.x * transform.basis.x) + (input_vector.z * transform.basis.z)
	return direction

func apply_movement(input_vector, direction, delta):
	if direction != Vector3.ZERO:
		velocity.x = velocity.move_toward(direction * speed, acceleration * delta).x
		velocity.z = velocity.move_toward(direction * speed, acceleration * delta).z

func apply_gravity(delta):
	velocity.y += gravity * delta
	velocity.y = clamp(velocity.y, gravity, jump_impulse)

func apply_friction(direction, delta):
	if direction == Vector3.ZERO:
		if is_on_floor():
			velocity = velocity.move_toward(Vector3.ZERO, friction * delta)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#do_color_change(delta)
	
	if Input.is_action_just_pressed("shoot"):
		var bullet_inst = bullet_scene.instance()
		
		get_tree().get_root().add_child(bullet_inst)
		
		bullet_inst.transform.origin = transform.origin
		bullet_inst.transform.origin += Vector3(0,2,0)
		bullet_inst.rotation_degrees = Vector3(0,180,0) #temp
		
		bullet_inst.connect("bullet_killed", self, "my_bullet_is_dead")
		#add_child(new_inst)
	
func my_bullet_is_dead(points):
	print("my Bullet just hit something")
	
func do_color_change(delta):
	time_to_color_change -= delta
	if time_to_color_change <= 0:
		time_to_color_change += color_change_delay
		
		#var mesh_node = get_node("player_mesh")
		var mesh_node = $player_mesh
		
		mesh_node.get_active_material(0).albedo_color = Color(randf(), randf(), randf())
	
#func do_movement():
#	var velocity = Vector3.ZERO
#	for action in direction_map:
#		if Input.is_action_pressed(action):
#			velocity += direction_map[action]
#	#transform.origin += Vector3(0, 0, -speed * delta)
#	velocity = velocity.normalized()
	
#	move_and_slide(velocity * speed, Vector3.UP)

#func _input(ev):
#	if ev is InputEventKey and ev.scancode == KEY_K:
#		transform.origin += Vector3(speed * delta,0, 0)
