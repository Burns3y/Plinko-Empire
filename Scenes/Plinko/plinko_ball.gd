extends RigidBody2D

var value: int = 1

func _ready():
	$Timer.start()
	# Each ball has a 1 in 100 chance of having extra bounce, to increase randomness.
	if randi() % 250 == 1:
		print("Magic")
		$".".physics_material_override.bounce = 0.5

	else: 
		$".".physics_material_override.bounce = 0.33
		$".".physics_material_override.bounce += randf_range(-0.15, 0.06)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if global_position.y > 1280:
		GlobalVariables.free_balls.append(value)
		print("Free ball added, value", value)

		# popup where ball exited
		var popup_scene = preload("res://Scenes/Plinko/plinko_popups.tscn")
		var popup = popup_scene.instantiate()
		var popup_pos = global_position

		# Clamp to safe viewport area
		var viewport_rect = get_viewport_rect()
		popup_pos.x = clamp(popup_pos.x, 100 + randf_range(0, 100), viewport_rect.size.x - 200 - randf_range(0, 100))
		popup_pos.y = clamp(popup_pos.y, 200, viewport_rect.size.y - 200)

		popup.position = popup_pos
		popup.rotation = randf_range(-0.3, 0.3) # slight tilt
		get_tree().root.add_child(popup)
		popup._show_popup("+ Free $" + str(value) + " Ball!", true)

		queue_free()

func _on_timer_timeout():
	if global_position.x == 0:
		linear_velocity.x = 15
	else:
		linear_velocity.x = sign(global_position.x - 360) * 15

	if $Timer.wait_time >= 2:
		$Timer.wait_time -= 2
	$Timer.start()
