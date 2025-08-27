extends Control

func _update_label():
	var num: float
	var decimals: int

	# Decide what we're displaying based on the node's name
	if self.name == "CoinDisplay":
		num = GlobalVariables.coins
		decimals = 2
	elif self.name == "IncomeDisplay":
		num = GlobalVariables.income_per_minute
		decimals = 0
	else:
		return # nothing to update

	$Label.text = format_abbreviated(num, decimals)


func format_abbreviated(value, decimals):
	var text = UsefulFunctions._format_abbreviated(value, decimals)

	if self.name == "CoinDisplay":
		return text
	elif self.name == "IncomeDisplay":
		return "$" + text + "/ min"
