extends Control

func _update_label():
	var num = GlobalVariables.coins
	$Label.text = format_abbreviated(num)

func format_abbreviated(value: float):
	var suffixes = ["", "K", "M", "B", "T", "Q"]
	var suffix_index = 0

	# Keeps dividing by 1k until it finds the suffix
	while value >= 1000 and suffix_index < suffixes.size() - 1:
		value /= 1000.0
		suffix_index += 1


	# Makes it 2 Decimal places, then strips the trailing zeroes and decimal places
	var text = "%.2f" % value
	text = text.rstrip("0").rstrip(".")

	return text + suffixes[suffix_index]
