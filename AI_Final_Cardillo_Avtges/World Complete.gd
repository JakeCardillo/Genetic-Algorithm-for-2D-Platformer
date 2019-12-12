# World Complete.gd

extends Area2D
export(String, FILE, "world.tscn") var next_world

#go to next world when hitting end
func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if body.name == "Player":
			get_tree().change_scene(next_world)