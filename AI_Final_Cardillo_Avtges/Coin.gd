extends Area2D

#Removes coin from world when picked up
func _on_Coin_body_entered(body):
	queue_free()