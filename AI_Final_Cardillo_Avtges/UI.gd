extends Control

#update text when a coin is collected
func _on_Coin_body_entered(body):
	Global.coins += 1
	var coinsLabel = get_node("CanvasLayer/VBoxContainer/Coins")
	coinsLabel.set_text("Coins: %d" % Global.coins)
