extends Area

onready var player = get_tree().get_nodes_in_group("player")[0]


func _on_Level_Trans_body_entered(body):
	if body == player:
		get_tree().change_scene("res://MainMenu.tscn")
