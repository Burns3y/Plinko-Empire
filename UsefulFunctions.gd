extends Node

func _format_abbreviated(value, decimals):
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
	
	return text + suffixes[suffix_index]
