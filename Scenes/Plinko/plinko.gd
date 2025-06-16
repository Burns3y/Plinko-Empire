extends Node2D

# Setting up the row generation
@export var rows: int = 6
var pin_scale

# Preloading balls and pins
var ball: PackedScene = preload("res://Scenes/Plinko/plinko_ball.tscn")
var pin: PackedScene = preload("res://Scenes/Plinko/plinko_pin.tscn")

# Preloading multipliers
var zeroPointEightMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/point_8_multiplier.tscn")
var onePointFiveMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/1_point_5x_multiplier.tscn")
var threeMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/3x_multiplier.tscn")
var fiveMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/5x_multiplier.tscn")
var fiftyMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/50x_multiplier.tscn")
var hundredMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/100x_multiplier.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var t = float(rows - 4) / 4.0
	pin_scale = lerp(1.5, 1.1, t)
	create_rows()

func _on_ball_drop_pressed():
	
	# Checking if the ball will be "magic"
	var magic_ball = false
	if randi() % ((rows + 30) * 5) == 1:
		magic_ball = true
	
	# Instantiating ball
	var new_ball = ball.instantiate()
	
	# Setting range of ball positions
	var new_ball_pos = randf_range(-9, 9)
	if rows == 9:
		new_ball_pos = randf_range(-7.4, 7.4)
	if rows == 10:
		new_ball_pos = randf_range(-5.4, 5.4)

	# Rescaling ball (only works if you rescale children)
	for child in new_ball.get_children():
		if child is CollisionShape2D or child is Sprite2D:
			child.scale *= Vector2(pin_scale*0.16, pin_scale*0.16)

	new_ball.name = "Ball"
	### CHANGE WHEN CASH IS CHANGEABLE
	new_ball.value = 1
	GlobalVariables.coins -= new_ball.value
	
	$Balls.add_child(new_ball)
	if not magic_ball:
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos, 0)
		# Pins have a slightly random bounce size, smaller if more rows
		new_ball.physics_material_override.bounce = randf_range((1.0 / rows + 16) * 0.002, (1.0 / rows + 16) * 0.004)

	else:
		# Gives it more bounce and a further spawn point
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos*2, 0)
		new_ball.physics_material_override.bounce = 0.35
		magic_ball = false

func create_rows():
	var x_spacing = 580 / (rows + 1)
	var y_spacing = 700 / (rows + 2)

	var start_position: Vector2 = Vector2(360 - x_spacing, 500)
	var new_pos = start_position
	var col_count = 3
	var final_pin_location

	for row in range(rows):
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
	create_multipliers("a", y_spacing, x_spacing, final_pin_location)

func create_multipliers(distribution, y_spacing, x_spacing, final_pin_location):
	var distribution_5 = [fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier]
	var distribution_6 = [fiveMultiplier, threeMultiplier, onePointFiveMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier]
	var distribution_7 = [fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier]
	var distribution_8 = [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
	var distribution_9 = [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
	var distribution_10 = [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
	
	#Finding multiplier size and spacing
	var multiplier_width = 40 * pin_scale
	var starting_position = Vector2(final_pin_location.x + x_spacing/2 - 20 * pin_scale, final_pin_location.y + y_spacing*0.8)

	# Placing the multipliers
	var multiplier_count = 0
	for multiplier in distribution_6:
		var new_multiplier = multiplier.instantiate()
		new_multiplier.position = starting_position - Vector2(multiplier_count * x_spacing, 0)
		new_multiplier.scale = Vector2(pin_scale, pin_scale)
		$Multipliers.add_child(new_multiplier)
		multiplier_count += 1

		new_multiplier.connect("add_points", self._on_multiplier_hit)
	
func _on_multiplier_hit(multiplier_value, ball_colliding):
	GlobalVariables.coins += ball_colliding.value * multiplier_value
	ball_colliding.queue_free()
	print(GlobalVariables.coins)
