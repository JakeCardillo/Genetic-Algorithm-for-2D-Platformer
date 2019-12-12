extends Node

const UP = Vector2(0, -1)

#gene variables
var GRAVITY = 20
var MAX_SPEED = 250
var JUMP_HEIGHT = -550
var ACCELERATION = 50

var coins = 0

#GA Stuffs
var runCounter = 0
var counter = 0
var generation = 0

#12 organisms with 4 alleles
#var genes = [
#[18, 388, -550, 50], [20, 292, -708, 58], 
#[20, 322, -655, 30], [20, 379, -557, 42],
#[20, 209, -583, 72], [21, 331, -728, 70],
#[20, 277, -661, 56], [19, 396, -679, 56],
#[20, 269, -627, 55], [19, 326, -695, 32],
#[20, 249, -715, 78], [20, 383, -550, 58]]

#example of generation 5
var genes = [
[18, 362, -550, 50], [17, 369, -544, 48], 
[15, 363, -550, 50], [17, 369, -551, 48],
[17, 369, -548, 51], [17, 361, -550, 50],
[17, 369, -552, 51], [17, 362, -550, 50],
[16, 369, -550, 50], [17, 369, -544, 50],
[15, 369, -550, 50], [17, 369, -557, 50]]
var scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

#Loads next player stats and handles child generation
func next_player():
	
	if(counter % 2 == 0):
		if(runCounter < 12):
			#set new genes
			GRAVITY = genes[runCounter][0]
			MAX_SPEED = genes[runCounter][1]
			JUMP_HEIGHT = genes[runCounter][2]
			ACCELERATION = genes[runCounter][3]
			runCounter += 1
		else: #Generate children
			#export data to file
			var file = File.new()
			var fileName = ("C:/Users/jcard/Documents/AI Data/generation%d.txt" % generation)
			file.open(fileName, File.WRITE)
			
			var x = 0
			for gene in genes:
				file.store_line("G: %d  SP: %d  J: %d  ACC: %d" % gene)
				file.store_line("Score: %d" % scores[x])
				x += 1
			file.close()
			
			#GA variables
			var topParents = []
			var children = []
			var maxPos = 0
			var maxVal = 0
			
			#find best parents
			for i in range(0, 6):
				for j in range(0, 12):
					if scores[j] > maxVal:
						maxVal = scores[j]
						maxPos = j
				topParents.append(genes[maxPos])
				scores[maxPos] = -5
			
			#sexual reproduction
			#3 pairs of parents each make 4 children
			for i in range(0, 3):
				#1 point swap, each child gets [g][sp] from parent 1 and [j][acc] from parent 2
				children.append([topParents[i*2][0] + randi() % 4 - 2, topParents[i*2][1] + randi() % 20 - 10, topParents[i*2+1][2], topParents[i*2+1][3]])
				children.append([topParents[i*2+1][0] + randi() % 4 - 2, topParents[i*2+1][1] + randi() % 20 - 10, topParents[i*2][2], topParents[i*2][3]])
				
				#2 point swap, each child gets [sp][j] from parent 1 and [g][acc] from parent 2
				children.append([topParents[i*2][0], topParents[i*2+1][1], topParents[i*2+1][2] + randi() % 20 - 10, topParents[i*2][3] + randi() % 4 - 2])
				children.append([topParents[i*2+1][0], topParents[i*2][1], topParents[i*2][2] + randi() % 20 - 10, topParents[i*2+1][3] + randi() % 4 - 2])
				
				#swapped alleles are affected by a randomness factor
			
			#set children as new runners
			genes = children
			scores = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
			runCounter = 0
			
			print("genes have been changed")
			generation += 1
			
	#reset vars
	counter += 1
	coins = 0
	