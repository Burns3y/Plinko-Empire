extends Node2D

# Setting up the row generation
@export var rows: int = 6
@export var x_spacing: float = 40.0
@export var y_spacing: float = 70.0
var pin_scale

# Preloading balls and pins
var ball: PackedScene = preload("res://Scenes/Plinko/plinko_ball.tscn")
var pin: PackedScene = preload("res://Scenes/Plinko/plinko_pin.tscn")

# Preloading multipliers
var zeroPointEightMultiplier: PackedScene = preload("res://Scenes/point_8_multiplier.tscn")
var onePointFiveMultiplier: PackedScene = preload("res://Scenes/Plinko/Multipliers/1.5x_multiplier.tscn")
var threeMultiplier: PackedScene = preload("res://Scenes/3x_multiplier.tscn")
var fiveMultiplier: PackedScene = preload("res://Scenes/5x_multiplier.tscn")
var fiftyMultiplier: PackedScene = preload("res://Scenes/50x_multiplier.tscn")
var hundredMultiplier: PackedScene = preload("res://Scenes/100x_multiplier.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var t = float(rows - 4) / 4.0
	pin_scale = lerp(1.5, 1.0, t)
	create_rows()

func _process(delta):
	pass

func _on_ball_drop_pressed():
	var magic_ball = false
	if randi() % ((rows + 30) * 5) == 1:
		magic_ball = true
		print("magicball")

	var new_ball = ball.instantiate()
	var new_ball_pos = randf_range(-9, 9)
	if rows == 9:
		new_ball_pos = randf_range(-7.4, 7.4)
	if rows > 9:
		new_ball_pos = randf_range(-5.4, 5.4)

	for child in new_ball.get_children():
		child.scale *= Vector2(pin_scale*0.16, pin_scale*0.16)

	new_ball.name = "Ball"
	$Balls.add_child(new_ball)
	if not magic_ball:
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos, 0)
		# Pins have a slightly random bounce size, smaller if more rows
		randf_range((1.0 / rows + 17) * 0.009, (1.0 / rows + 17) * 0.011)

	else:
		#Gives it more bounce and a further spawn point
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos*2, 0)
		new_ball.physics_material_override.bounce = 0.35

func create_rows():
	x_spacing = 580 / (rows + 1)
	y_spacing = 700 / (rows + 2)

	var start_position: Vector2 = Vector2(360 - x_spacing, 500)
	var new_pos = start_position
	var col_count = 3

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
		col_count += 1

func create_multipliers(distribution, y_spacing, x_spacing):
	var distribution_5 = [fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier]
	var distribution_6 = [fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier]
	var distribution_7 = [fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier]
	var distribution_8 = [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
	var distribution_9 = [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
	var distribution_10 = [hundredMultiplier, fiftyMultiplier, fiveMultiplier, threeMultiplier, onePointFiveMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, zeroPointEightMultiplier, onePointFiveMultiplier, threeMultiplier, fiveMultiplier, fiftyMultiplier, hundredMultiplier]
	
	#Finding multiplier size and spacing
	var multiplier_count: int = 0
	var starting_position: Vector2 # x spacing and y spacing
	
	# Placing the multipliers
	for multiplier in distribution:
		multiplier.instantiate()
		$Multipliers.add_child(multiplier)
		multiplier.position = starting_position + Vector2(multiplier_count * x_spacing, 0)
		multiplier.scale = Vector2(pin_scale, pin_scale)
		multiplier_count += 1
