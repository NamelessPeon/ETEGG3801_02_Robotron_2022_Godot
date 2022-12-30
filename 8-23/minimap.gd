extends Camera

export(NodePath) var target
#onready var player = get_tree().get_nodes_in_group("player")[0]
onready var player = get_node(target)

func _physics_process(delta):
	translation = Vector3(player.translation.x, 30, player.translation.z)
