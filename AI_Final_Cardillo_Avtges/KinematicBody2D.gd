extends KinematicBody2D

var motion = Vector2()
var jump = false
var land = false
var timer = 1

func _physics_process(delta):
	var frog = get_parent().get_node("World Complete")
	motion.y += Global.GRAVITY
	var friction = false
	
	#End Run
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://StartMenu.tscn")
	
	#Player Movement
	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + Global.ACCELERATION, Global.MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
	elif Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - Global.ACCELERATION, -Global.MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	else:
		friction = true
		#$Sprite.play("Idle")
	
	#Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = Global.JUMP_HEIGHT
		if friction:
			motion.x = lerp(motion.x, 0, 0.2)
	else:
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
		if friction:
			motion.x = lerp(motion.x, 0, 0.05)
	
	motion = move_and_slide(motion, Global.UP)
	
	#************REACTIVE AI***************
	
	#Move towards frog
	if frog.position.x > position.x:
		motion.x = min(motion.x + Global.ACCELERATION, Global.MAX_SPEED)
		$Sprite.flip_h = false
		$Sprite.play("Run")
	else:
		motion.x = max(motion.x - Global.ACCELERATION, -Global.MAX_SPEED)
		$Sprite.flip_h = true
		$Sprite.play("Run")
	
	#jump if bumping into a wall
	if is_on_wall():
		if timer > 0:
			timer -= delta
		else:
			jump = true
			timer = .5
	
	#Jump
	if jump:
		motion.y = Global.JUMP_HEIGHT
			
		if motion.y < 0:
			$Sprite.play("Jump")
		else:
			$Sprite.play("Fall")
		if friction:
			motion.x = lerp(motion.x, 0, 0.05)
		jump = false
	
	#Search for a place to land
	if land:
		motion.x = 0
		if is_on_floor():
			land = false

#Jump if we see a ledge
func _on_Feet_body_exited(body):
	if is_on_floor():
		jump = true

#Search for a place to land
func _on_Below_body_entered(body):
	if !is_on_floor():
		land = true

#Runs when we reach the frog
func _on_World_Complete_body_entered(body):
	Global.next_player() #set up next players stats
	#update labels
	var runLabel = get_node("UI/CanvasLayer/VBoxContainer/Run #")
	runLabel.set_text("Organism %d" % Global.runCounter)
	var statsLabel = get_node("UI/CanvasLayer/VBoxContainer/Stats")
	statsLabel.set_text("G: %d  SP: %d  J: %d  ACC: %d" % Global.genes[Global.runCounter - 1])

#Score computation
#5 points for completing the level + 1 point for each coin
func _on_Area2D_body_entered(body):
	Global.scores[Global.runCounter - 1] = 5 + Global.coins
