extends Camera2D

var min_zoom = 0.5
var max_zoom = 2
var zoom_speed = 0.05
var zoom_sensitivity = 10

var events = {}
var last_drag_diswtance

func _process(delta):
	pass

func _unhandled_input(event):
	# If screen touched, add event to dictionary
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
		
	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			position -= event.relative * zoom.x
