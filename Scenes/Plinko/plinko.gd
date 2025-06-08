extends Node2D

# Setting up the row generation
@export var rows: int = 6
@export var x_spacing: float = 40.0
@export var y_spacing: float = 70.0
var pin_scale

# Preloading balls and pins
var ball: PackedScene = preload("res://Scenes/Plinko/plinko_ball.tscn")
var pin: PackedScene = preload("res://Scenes/Plinko/plinko_pin.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var t = float(rows - 4) / 4.0
	pin_scale = lerp(1.5, 1.0, t)
	create_rows()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_drop_pressed():
	
	var magic_ball = true
	if randi() % ((rows + 40) * 5) == 1:
		magic_ball = true
	
	var new_ball = ball.instantiate()
	var new_ball_pos = randf_range(-9, 9)
	if rows > 9:
		new_ball_pos = randf_range(-5.4, 5.4)
	
	# Setting scale of children
	for child in new_ball.get_children():
		child.scale *= Vector2(pin_scale*0.16, pin_scale*0.16)

	new_ball.name = "Ball"
	$Balls.add_child(new_ball)
	if not magic_ball:
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos, 0)
	else:
		new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos*1.8, 0)
		new_ball.physics_material_override.bounce = 0.35

func create_rows():
	# Changing pin spacing and size based on size of rows
	x_spacing = 580/(rows+1)
	y_spacing = 700/(rows+2)
	print(pin_scale)
	
	# Where the pin starts
	var start_position: Vector2 = Vector2(360 - x_spacing, 500)
	var new_pos = start_position
	var col_count = 3
	
	# Placing the pins
	for row in range(rows):
		new_pos.y += y_spacing
		new_pos.x = start_position.x - row*x_spacing/2
		for col in range(col_count):
			var new_pin = pin.instantiate()
			new_pin.name = "pin"
			$Pins.add_child(new_pin)
			new_pin.position = new_pos
			new_pin.scale = Vector2(pin_scale, pin_scale)
			new_pos.x += x_spacing
		col_count += 1
