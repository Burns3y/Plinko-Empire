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

	# Setting up datetime
	GlobalVariables.initial_datetime = Time.get_unix_time_from_system()

	file.store_var(GlobalVariables.income_per_minute)
	file.store_var(GlobalVariables.coins)
	file.store_var(GlobalVariables.max_rows)
	file.store_var(GlobalVariables.new_row_cost)
	
	file.store_var(GlobalVariables.initial_datetime)
	
	# Save background state
	file.store_var(GlobalVariables.selected_bg) # string
	var jstr = JSON.stringify(GlobalVariables.bought_bg)
	file.store_line(jstr)   # dictionary
	
	# Save buildings
	var bg_jstr = JSON.stringify(GlobalVariables.bought_bg)
	file.store_line(bg_jstr) 


func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		GlobalVariables.income_per_minute = file.get_var()
		GlobalVariables.coins = file.get_var()
		GlobalVariables.max_rows = file.get_var()
		GlobalVariables.new_row_cost = file.get_var()
		GlobalVariables.initial_datetime = file.get_var()

		# Load background state
		GlobalVariables.selected_bg = file.get_var()
		var bg_str = JSON.parse_string(file.get_line())
		if bg_str:
			GlobalVariables.bought_bg = bg_str
			
		# Load Bought Buildings
		var building_str = JSON.parse_string(file.get_line())
		if building_str:
			GlobalVariables.bought_bg = building_str

		GlobalVariables.coins += clamp((Time.get_unix_time_from_system() - GlobalVariables.initial_datetime)/60, 0, 100 * GlobalVariables.income_per_minute)


func reset():
	# Delete the save file if it exists
	if FileAccess.file_exists(save_path):
		var err = DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
		if err != OK:
			push_error("Failed to delete save file: " + str(err))
	
	# Replace all variables
	GlobalVariables.income_per_minute = GlobalVariables.initial_income_per_minute
	GlobalVariables.coins = GlobalVariables.initial_coins
	GlobalVariables.max_rows = GlobalVariables.initial_max_rows
	GlobalVariables.new_row_cost = GlobalVariables.initial_new_row_cost
	
		# Reset backgrounds
	GlobalVariables.bought_bg = {
		"Purple": true,
		"Blue": false,
		"Pink": false,
		"Red": false,
		"Green": false,
		"Orange": false,
		"Teal": false,
		"Gold": false,
	}
	
	GlobalVariables.buildings_bought = {
		100: false,
		500: false,
		1000: false,
		5000: false,
		10000: false,
		50000: false,
		100000: false,
		500000: false,
		1000000: false,
		50000000: false,
		1000000000: false,
	}

	GlobalVariables.selected_bg = "Purple"
	save()


func _format_abbreviated(value, decimals = 0):
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
