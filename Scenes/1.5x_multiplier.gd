extends ColorRect

signal add_points

var multiplier: float = 0.8

func _on_collision_box_body_entered(body):
	emit_signal("add_points", multiplier)
