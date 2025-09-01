extends Control

# Setting up the row generation
var pin_scale

# Preloading balls and pins
var ball: PackedScene = preload("res://Scenes/Plinko/plinko_ball.tscn")
var pin: PackedScene = preload("res://Scenes/Plinko/plinko_pin.tscn")
var ball_value: int = 1

# Preloading popups
var popup: PackedScene = preload("res://Scenes/Plinko/plinko_popups.tscn")

# Preloading multipliers
var zeroPointTwoMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/point_2_multiplier.tscn")
var zeroPointFiveMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/point_5_multiplier.tscn")
var oneMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/1x_multiplier.tscn")
var threeMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/3x_multiplier.tscn")
var fiveMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/5x_multiplier.tscn")
var tenMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/10x_multiplier.tscn")
var fiftyMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/50x_multiplier.tscn")
var hundredMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/100x_multiplier.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.connect("size_changed", self._on_viewport_size_changed)
	$Displays/CoinDisplay._update_label()
	$Displays/IncomeDisplay._update_label()
	
	# Background
	if GlobalVariables.selected_bg != "Gold":
		$"Plinko-background".modulate = Color(1, 1, 1)
	if GlobalVariables.selected_bg == "Purple":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/Plinko-background.png")
	elif GlobalVariables.selected_bg == "Blue":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_blue.png")
	elif GlobalVariables.selected_bg == "Green":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_green.png")
	elif GlobalVariables.selected_bg == "Orange":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_orange.png")
	elif GlobalVariables.selected_bg == "Red":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_red.png")
	elif GlobalVariables.selected_bg == "Pink":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_pink.png")
	elif GlobalVariables.selected_bg == "Teal":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_teal.png")
	elif GlobalVariables.selected_bg == "Gold":
		$"Plinko-background".texture = load("res://Assets/backgrounds_variations/background_gold.png")
		$"Plinko-background".modulate = Color(0.8, 0.8, 0.8)
		
	
	# Setting pin scale depending on rows
	if get_viewport_rect().size != Vector2(720, 1280):
		_on_viewport_size_changed()
	else:
		var t = float(GlobalVariables.current_rows - 4) / 4.0
		var base_pin_scale = lerp(1.5, 1.1, float(GlobalVariables.current_rows - 4) / 4.0)
		pin_scale = base_pin_scale * (get_viewport_rect().size.x / 720)
		$Sliders/RowSlider.max_value = GlobalVariables.max_rows
		create_rows()


func _on_ball_drop_pressed():
	# If you have enough money to drop a ball, lets you
	if GlobalVariables.coins < $Sliders/BallAmountSlider.value:
		_bad_popup("Not Enough Money!")

	else:
		# Instantiating ball
		var new_ball = ball.instantiate()
		
		# Setting ball spawn point range
		var new_ball_pos = randf_range(-30, 30)

		# Rescaling ball (only works if you rescale children)
		for child in new_ball.get_children():
			if child is CollisionShape2D or child is Sprite2D:
				child.scale *= Vector2(pin_scale*0.15, pin_scale*0.15)

		new_ball.name = "Ball"
		
		# Giving the ball a value, subtracting from global
		if GlobalVariables.free_balls == []:
			new_ball.value = ball_value
			GlobalVariables.coins -= new_ball.value
		else:
			new_ball.value = GlobalVariables.free_balls.pop_front()
			print("Free ball used, value ", new_ball.value, "\nFree balls left: ", len(GlobalVariables.free_balls))
		GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
		UsefulFunctions.save()
		$Displays/CoinDisplay._update_label()
		
		$Balls.add_child(new_ball)
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos, 0)

	UsefulFunctions.save()



func create_rows():
	var viewport_size = get_viewport_rect().size

	# Use ratios instead of fixed values
	var x_spacing = (viewport_size.x * 0.8) / (GlobalVariables.current_rows + 1)
	var y_spacing = (viewport_size.y * 0.55) / (GlobalVariables.current_rows + 2)

	# Start a bit below the top middle
	var start_position = Vector2(viewport_size.x / 2 - x_spacing, viewport_size.y * 0.4)

	var new_pos = start_position
	var col_count = 3
	var final_pin_location

	for row in range(GlobalVariables.current_rows):
		new_pos.y += y_spacing
		new_pos.x = start_position.x - row * x_spacing / 2
		for col in range(col_count):
			var new_pin = pin.instantiate()
			new_pin.name = "pin"
			$Pins.add_child(new_pin)
			new_pin.position = new_pos
			new_pin.scale = Vector2(pin_scale, pin_scale)
			new_pos.x += x_spacing
			final_pin_location = new_pin.position
		col_count += 1
	
	# Multipliers
	create_multipliers(y_spacing, x_spacing, final_pin_location)

func create_multipliers(y_spacing, x_spacing, final_pin_location):
	var distributions = {
		6: [fiftyMultiplier, fiveMultiplier, threeMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier],
		7: [hundredMultiplier, fiveMultiplier, fiveMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, fiveMultiplier, fiveMultiplier, hundredMultiplier],
		8: [hundredMultiplier, tenMultiplier, fiveMultiplier, threeMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, threeMultiplier, fiveMultiplier, tenMultiplier, hundredMultiplier],
		9: [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier],
		10: [hundredMultiplier, hundredMultiplier, fiftyMultiplier, tenMultiplier, threeMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, threeMultiplier, tenMultiplier, fiftyMultiplier, hundredMultiplier, hundredMultiplier]
	}
	
	# Getting distribution
	var selected_distribution = distributions.get(GlobalVariables.current_rows, [])
	
	#Finding multiplier spacing
	var starting_position = Vector2(final_pin_location.x + x_spacing/2 - 20 * pin_scale, final_pin_location.y + y_spacing*0.8)

	# Placing the multipliers
	var multiplier_count = 0
	for multiplier in selected_distribution:
		var new_multiplier = multiplier.instantiate()
		new_multiplier.position = starting_position - Vector2(multiplier_count * x_spacing, 0)
		new_multiplier.scale = Vector2(pin_scale, pin_scale)
		$Multipliers.add_child(new_multiplier)
		multiplier_count += 1

		new_multiplier.connect("add_points", self._on_multiplier_hit)
	
func _on_multiplier_hit(multiplier_value, ball_colliding):
	'''Adds value of multiplier * value of ball to global coins'''
	GlobalVariables.coins += ball_colliding.value * multiplier_value
	GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
	$Displays/CoinDisplay._update_label()
	ball_colliding.queue_free()
	$Displays/MultiplierDisplay.rearrange_multipliers(multiplier_value)
	
	UsefulFunctions.save()


func _on_row_slider_value_changed(value):
	GlobalVariables.current_rows = value - 2

	# Wait until there are no balls left in $Balls
	if $Balls.get_child_count() > 0 and GlobalVariables.max_rows != 8:
		$Buttons/BallDrop.disabled = true
		_bad_popup("Waiting until balls\nhave stopped dropping!")
		$Buttons/BuyButton.disabled = true
	while $Balls.get_child_count() > 0:
		await get_tree().process_frame

	# Removing and replacing everything based on screen size
	_on_viewport_size_changed()
	$Buttons/BuyButton.disabled = false
	

	# Setting text and reenabling button
	$Sliders/RowSlider/RowNumberLabel.text = "Rows:         " + str(GlobalVariables.current_rows + 2)
	
	$Buttons/BallDrop.disabled = false
	
	# Setting maximum and minimum ball values so that they scale depending on row count
	if $Sliders/RowSlider.value == $Sliders/RowSlider.min_value:
		$Sliders/BallAmountSlider.min_value = 1
	else:
		$Sliders/BallAmountSlider.min_value = (GlobalVariables.current_rows - 6) * 10
	$Sliders/BallAmountSlider.max_value = (GlobalVariables.current_rows - 5) * 50
	$Sliders/BallAmountSlider/BallAmountLabel.text = "Ball value: $" + str(ball_value)
	
	UsefulFunctions.save()


func _on_ball_amount_slider_value_changed(value):
	ball_value = value
	$Sliders/BallAmountSlider/BallAmountLabel.text = "Ball value: $" + str(ball_value)


func _on_exit_pressed():
	if $Balls.get_child_count() == 0:
		get_tree().change_scene_to_file("res://Scenes/map.tscn")
	else:
		print("Wait until balls have stopped dropping!")
		_bad_popup("Waiting until balls\nhave stopped dropping!")
	
	UsefulFunctions.save()


func _on_buy_button_pressed():
	if GlobalVariables.coins >= GlobalVariables.new_row_cost:
		if GlobalVariables.current_rows < 10:
			GlobalVariables.coins -= GlobalVariables.new_row_cost
			GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
			$Displays/CoinDisplay._update_label()
			GlobalVariables.new_row_cost *= 25
			if GlobalVariables.max_rows < 12:
				GlobalVariables.max_rows += 1
			$Sliders/RowSlider.max_value = GlobalVariables.max_rows
			$Sliders/RowSlider.value = $Sliders/RowSlider.max_value
			UsefulFunctions.save()
			
			if GlobalVariables.max_rows == 12:
				$Buttons/BuyButton.visible = false
			else:
				$Buttons/BuyButton.text = "Buy Row\n$" + UsefulFunctions._format_abbreviated(GlobalVariables.new_row_cost, 2)
		else:
			$Buttons/BuyButton.visible = false
	else:
		_bad_popup("Not Enough Money!")
	
	UsefulFunctions.save()


func _clear_all():
	for multiplier in $Multipliers.get_children():
		multiplier.queue_free()
	for child in $Pins.get_children():
		child.queue_free()


func _bad_popup(statement: String):
	var bad_popup = popup.instantiate()
	bad_popup.position = $BallSpawnPoint.position - Vector2(50, 0)
	for child in $Popups/BadPopups.get_children(): child.clear_self()
	$Popups/BadPopups.add_child(bad_popup)
	bad_popup._show_popup(statement, false)


func _on_viewport_size_changed():
	# Clear pins + multipliers and recreate them
	_clear_all()
	for slider in $Sliders.get_children():
		slider.size_flags_vertical = Control.SIZE_EXPAND
	var base_pin_scale = lerp(1.5, 1.1, float(GlobalVariables.current_rows - 4) / 4.0)
	pin_scale = base_pin_scale * (get_viewport_rect().size.x / 720)
	$BallSpawnPoint.position.x = get_viewport_rect().size.x / 2
	$BallSpawnPoint.position.y = get_viewport_rect().size.y * 0.4
	create_rows()
	
	UsefulFunctions.save()

