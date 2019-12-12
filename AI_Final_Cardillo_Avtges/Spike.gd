# Spike.gd
extends Area2D

func _physics_process(delta):
	#detect spike collision
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			#run next player functions
			Global.scores[Global.runCounter - 1] = Global.coins
			Global.next_player()
			
			#go to world 2
			get_tree().change_scene("res://World2.tscn")