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
	var suffixes = ["", "K", "M", "B", "T", "Q"]
	var suffix_index = 0

	# Keeps dividing by 1k until it finds the suffix
	while value >= 1000 and suffix_index < suffixes.size() - 1:
		value /= 1000.0
		suffix_index += 1

	# Always round down to avoid early jumps
	var factor = pow(10, decimals)
	value = floor(value * factor) / factor

	# Apply formatting with correct decimal places
	var fmt = "%." + str(decimals) + "f"
	var text = fmt % value

	# Strip trailing zeros/decimal point only if decimals > 0
	if decimals > 0:
		text = text.rstrip("0").rstrip(".")
		
	if self.name == "CoinDisplay":
		return text + suffixes[suffix_index]
	elif self.name == "IncomeDisplay":
		return text + suffixes[suffix_index] + "/ min"
		
