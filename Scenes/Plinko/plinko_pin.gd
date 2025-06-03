extends Area2D

signal ball_entered

func _on_body_entered(body):
	var ball_velocity_x = randf_range(-70, 70)
	if body.is_in_group("Ball"):
		body.linear_velocity.y = -350
		body.linear_velocity.x += ball_velocity_x
