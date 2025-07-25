extends RigidBody2D

var value: int = 1

func _ready():
	$Timer.start()
	# Each ball has a 1 in 100 chance of having extra bounce, to increase randomness.
	if randi() % 250 == 1:
		print("Magic")
		$".".physics_material_override.bounce = 0.45

	else: 
		$".".physics_material_override.bounce = 0.33
		$".".physics_material_override.bounce += randf_range(-0.15, 0.05)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if global_position.y > 1280:
		GlobalVariables.free_balls.append(value)
		print("Free ball added, value", value)
		queue_free()

func _on_timer_timeout():
	if global_position.x == 0:
		linear_velocity.x = 15
	else:
		linear_velocity.x = sign(global_position.x - 360) * 15

	if $Timer.wait_time >= 2:
		$Timer.wait_time -= 2
	$Timer.start()
