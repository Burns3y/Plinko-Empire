extends ColorRect

signal add_points
var multiplier: float = 5

func _on_collision_box_body_entered(body):
	emit_signal("add_points", multiplier, body)
