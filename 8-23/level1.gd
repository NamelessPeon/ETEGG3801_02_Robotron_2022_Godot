extends Spatial

#onready var player = $Player


func _on_Timer_timeout():
	#get_tree().call_group("Enemy_Group", 'get_target_path', player.global_transform.origin)
	pass
