extends Area3D

var clicked: bool = false

func _input_event(_camera, event, _pos, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if InputMap.action_has_event("left_click", event):
			print("Clicked 3D button via Area3D!")
			hide()  # Hides this Area3D and all its children (mesh, etc.)
			$"../second_build".visible = true
			clicked = true
