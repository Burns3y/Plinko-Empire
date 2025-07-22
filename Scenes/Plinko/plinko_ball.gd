extends RigidBody2D

var value: int = 1

func _ready():
	$Timer.start()
	# Checking if the ball will be "magic"
	var magic_ball = false
	if randi() % 200 == 1:
		magic_ball = true
	
	if not magic_ball:
		# Pins have a slightly random bounce size, smaller if more rows
		$".".physics_material_override.bounce += randf_range(-1, 1)
		print($".".physics_material_override.bounce)

	else:
		# Gives it more bounce
		$".".physics_material_override.bounce = 0.35
		magic_ball = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if global_position.y > 1280:
		queue_free()

func _on_timer_timeout():
	if global_position.x == 0:
		linear_velocity.x = 15
	else:
		linear_velocity.x = sign(global_position.x - 360) * 15

	if $Timer.wait_time >= 2:
		$Timer.wait_time -= 2
	$Timer.start()
