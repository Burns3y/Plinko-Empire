extends Node2D

# Setting up the row generation
var pin_scale

# Preloading balls and pins
var ball: PackedScene = preload("res://Scenes/Plinko/plinko_ball.tscn")
var pin: PackedScene = preload("res://Scenes/Plinko/plinko_pin.tscn")
var ball_value: int = 1

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
	# Setting pin scale depending on rows
	var t = float(GlobalVariables.current_rows - 4) / 4.0
	pin_scale = lerp(1.5, 1.1, t)
	$CashDisplay.text = "Cash: $" + str(GlobalVariables.coins)
	$Sliders/RowSlider.max_value = GlobalVariables.max_rows
	create_rows()


func _on_ball_drop_pressed():
	
	# If you have enough money to drop a ball, lets you
	if GlobalVariables.coins < $Sliders/BallAmountSlider.value:
		print("Not Enough Money!")
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
		$CashDisplay.text = "Cash: $" + str(GlobalVariables.coins)
		
		$Balls.add_child(new_ball)
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos, 0)



func create_rows():
	var x_spacing = 580 / (GlobalVariables.current_rows + 1)
	var y_spacing = 700 / (GlobalVariables.current_rows + 2)

	var start_position: Vector2 = Vector2(360 - x_spacing, 500)
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
		6: [fiftyMultiplier, fiveMultiplier, oneMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, oneMultiplier, fiveMultiplier, fiftyMultiplier],
		7: [fiftyMultiplier, fiveMultiplier, threeMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier],
		8: [fiftyMultiplier, fiveMultiplier, threeMultiplier, oneMultiplier, oneMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, oneMultiplier, oneMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier],
		9: [hundredMultiplier, tenMultiplier, fiveMultiplier, oneMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, oneMultiplier, threeMultiplier, tenMultiplier, hundredMultiplier],
		10: [hundredMultiplier, fiftyMultiplier, tenMultiplier, fiveMultiplier, oneMultiplier, zeroPointFiveMultiplier, zeroPointTwoMultiplier, zeroPointFiveMultiplier, oneMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
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
	$CashDisplay.text = "Cash: $" + str(GlobalVariables.coins)
	ball_colliding.queue_free()
	$MultiplierDisplay.rearrange_multipliers(multiplier_value)


func _on_row_slider_value_changed(value):
	GlobalVariables.current_rows = value - 2
	$BallDrop.disabled = true

	# Wait until there are no balls left in $Balls
	while $Balls.get_child_count() > 0:
		await get_tree().process_frame

	# Removing everything
	for multiplier in $Multipliers.get_children():
		multiplier.queue_free()
	for child in $Pins.get_children():
		child.queue_free()

	# Replacing everything
	var t = float(GlobalVariables.current_rows - 4) / 4.0
	pin_scale = lerp(1.5, 1.1, t)
	create_rows()
	

	# Setting text and reenabling button
	$Sliders/RowSlider/RowNumberLabel.text = "Rows:         " + str(GlobalVariables.current_rows + 2)
	
	$BallDrop.disabled = false


func _on_ball_amount_slider_value_changed(value):
	ball_value = value
	$Sliders/BallAmountSlider/BallAmountLabel.text = "Ball value:  $" + str(ball_value)


func _on_exit_pressed():
	if $Balls.get_child_count() == 0:
		get_tree().change_scene_to_file("res://Scenes/map.tscn")
	else:
		print("Wait until balls have stopped dropping!")


func _on_buy_button_pressed():
	if GlobalVariables.coins >= GlobalVariables.new_row_cost:
		if GlobalVariables.current_rows < 10:
			GlobalVariables.current_rows += 1
			GlobalVariables.coins -= GlobalVariables.new_row_cost
			GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
			$CashDisplay.text = "Cash: $" + str(GlobalVariables.coins)
			GlobalVariables.new_row_cost *= 10
			if GlobalVariables.max_rows < 12:
				GlobalVariables.max_rows += 1
			$Sliders/RowSlider.max_value = GlobalVariables.max_rows
			$Sliders/RowSlider.value = $Sliders/RowSlider.max_value
			
			if GlobalVariables.max_rows == 12:
				$BuyButton.visible = false
			else:
				$BuyButton.text = "Buy Another Row - $" + str(GlobalVariables.new_row_cost)
		else:
			$BuyButton.visible = false
	else:
		print("Not Enough Money!")
