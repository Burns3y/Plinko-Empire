extends ColorRect

signal add_points
var multiplier: float = 10

func _on_collision_box_body_entered(body):
	add_points.emit(multiplier, body)
