extends Camera3D

var drag_sensitivity = 0.01
var zoom_sensitivity = 0.01
var events = {}

func _unhandled_input(event):
	# Track when fingers touch or lift
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event  # Just store the touch event
		else:
			events.erase(event.index)  # Finger lifted -> remove it

	# Track dragging motion
	elif event is InputEventScreenDrag:
		events[event.index] = event  # Update the touch with the drag

		# One finger: pan
		if events.size() == 1:
			var drag = event.relative
			var move = Vector3(-drag.x, 0, -drag.y) * drag_sensitivity
			translate_object_local(move)

		# Two fingers: pinch zoom
		elif events.size() == 2:
			var touches = events.values()
			if touches[0] is InputEventScreenDrag and touches[1] is InputEventScreenDrag:
				var p1_curr = touches[0].position
				var p2_curr = touches[1].position
				var p1_prev = p1_curr - touches[0].relative
				var p2_prev = p2_curr - touches[1].relative

				var prev_dist = p1_prev.distance_to(p2_prev)
				var curr_dist = p1_curr.distance_to(p2_curr)
				var zoom_change = (curr_dist - prev_dist) * -zoom_sensitivity

				translate_object_local(Vector3(0, 0, zoom_change))
