extends CanvasLayer

func _ready():
	$Menu/Displays/CoinDisplay._update_label()
	_refresh_buttons()


# Updates the state of all buttons (buy/select/selected)
func _refresh_buttons():
	for child in $Menu/VBoxContainer.get_children():
		if child is HBoxContainer:
			for colour in child.get_children():
				if colour.name in GlobalVariables.bought_bg:
					var bought = GlobalVariables.bought_bg[colour.name]
					for button in colour.get_children():
						if button is Button:
							if button.name == "Buy":
								button.visible = not bought
							elif button.name == "Select":
								button.visible = bought
								if GlobalVariables.selected_bg == colour.name:
									button.text = "Selected"
									button.disabled = true
								else:
									button.text = "Select"
									button.disabled = false

	UsefulFunctions.save()


# Handles background buying
func buy_bg(colour: String, price: int):
	if not GlobalVariables.bought_bg[colour] and GlobalVariables.coins >= price:
		GlobalVariables.coins -= price
		GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
		GlobalVariables.bought_bg[colour] = true
		select_bg(colour) # auto-select after buying
		$Menu/Displays/CoinDisplay._update_label()
		UsefulFunctions.save()


# Handles background selection
func select_bg(colour: String):
	GlobalVariables.selected_bg = colour
	_refresh_buttons()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_blue_buy_pressed():
	buy_bg("Blue", 100)


func _on_pink_buy_pressed():
	buy_bg("Pink", 500)


func _on_red_buy_pressed():
	buy_bg("Red", 500)


func _on_green_buy_pressed():
	buy_bg("Green", 10000)


func _on_orange_buy_pressed():
	buy_bg("Orange", 50000)


func _on_teal_buy_pressed():
	buy_bg("Teal", 100000)


func _on_gold_buy_pressed():
	buy_bg("Gold", 10000000)


func _on_purple_select_pressed():
	select_bg("Purple")


func _on_blue_select_pressed():
	select_bg("Blue")


func _on_pink_select_pressed():
	select_bg("Pink")


func _on_red_select_pressed():
	select_bg("Red")


func _on_green_select_pressed():
	select_bg("Green")


func _on_orange_select_pressed():
	select_bg("Orange")


func _on_teal_select_pressed():
	select_bg("Teal")


func _on_gold_select_pressed():
	select_bg("Gold")
