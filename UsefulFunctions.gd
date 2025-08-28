extends Node

# Setting up persistant storage
var save_path = "user://saves/savegame.save"

func save():
	# Make sure the folder exists
	var dir := DirAccess.open("user://")
	if dir == null:
		push_error("Could not open user:// directory!")
		return
	dir.make_dir_recursive("saves")

	# Now safely open the file
	var file := FileAccess.open(save_path, FileAccess.WRITE)
	if file == null:
		push_error("Failed to open save file: " + save_path)
		return

	file.store_var(GlobalVariables.income_per_minute)
	file.store_var(GlobalVariables.coins)
	file.store_var(GlobalVariables.max_rows)
	file.store_var(GlobalVariables.new_row_cost)


func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		GlobalVariables.income_per_minute = file.get_var(GlobalVariables.income_per_minute)
		GlobalVariables.coins = file.get_var(GlobalVariables.coins)
		GlobalVariables.max_rows = file.get_var(GlobalVariables.max_rows)
		GlobalVariables.new_row_cost = file.get_var(GlobalVariables.new_row_cost)


func reset():
	# Delete the save file if it exists
	if FileAccess.file_exists(save_path):
		var err = DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
		if err != OK:
			push_error("Failed to delete save file: " + str(err))
	
	# Replace all variables
	GlobalVariables.income_per_minute = GlobalVariables.initial_income_per_minute
	GlobalVariables.coins = GlobalVariables.initial_coins
	GlobalVariables.max_rows = GlobalVariables.inital_max_rows
	GlobalVariables.new_row_cost = GlobalVariables.new_row_cost


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
