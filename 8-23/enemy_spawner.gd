extends KinematicBody

var enemy_scene = preload("res://enemy.tscn")
export var health = 100
export var distance_from_spawner = 5.2
export var spawn_delay = 1.5
onready var spawn_timer = spawn_delay
var spawn_number = 3
var distance_arround_spawner = 360/spawn_number
export var total_spawn = 6



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func enemy_spawn(delta):
	#if total_spawn != 0:
	spawn_timer -= delta
	if spawn_timer <= 0:
		if total_spawn != 0:
			var spawned = 0
			spawn_timer += spawn_delay
			var random_angel = randi()%361
			var angel = random_angel
			while (spawned != spawn_number):
			
				var enemy_inst = enemy_scene.instance()
		
				var enemy_x  = distance_from_spawner * cos(angel) # cos in radians
				var enemy_y  = distance_from_spawner * sin(angel) # cos in radians
		
			
				self.add_child(enemy_inst)
				enemy_inst.transform.origin = transform.origin + Vector3(enemy_x, 0, enemy_y)
			
				angel += deg2rad(distance_arround_spawner)
				spawned += 1
				total_spawn -= 1
	
	
func _process(delta):

	enemy_spawn(delta)
	
	
	
