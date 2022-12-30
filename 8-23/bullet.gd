extends Area

signal bullet_killed(points)

var speed = 5.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	translate_object_local(Vector3(0, 0, speed * delta))

func hit_something(body):
	print("I hit ", body) # Replace with function body.
	emit_signal("bullet_killed", 100)
	queue_free()

