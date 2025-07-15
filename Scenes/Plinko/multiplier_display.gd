extends VBoxContainer

var multiplier_colours: Dictionary = {
"0.2": "ffff5a",
"1": "ffc850",
"3": "ffc850",
"5": "ff5a5a",
"10": "ff4b4f",
"50": "ff2328",
"100": "ff2328"
}

var queue = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for multiplier in $".".get_children():
		multiplier.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# When the multiplier is hit, sends a signal that adds the newest one to the queue
func rearrange_multipliers(multiplier_value):
	var new_multiplier = null
	var found_multiplier: bool = false
	
	# Finds a multiplier that isn't active
	for multiplier in $".".get_children():
		if not multiplier.visible:
			new_multiplier = multiplier
			break

	if new_multiplier == null:
		# If none available, reuse the oldest visible one
		new_multiplier = queue.pop_front()
	
	# Setting up the new multiplier
	new_multiplier.visible = true
	var label = new_multiplier.get_node("Label")
	label.text = str(multiplier_value)
	new_multiplier.color = ("#" + multiplier_colours.get(multiplier_value, "ffffff"))
	queue.append(new_multiplier)
	# If we now have more than 4 visible, hide the oldest (top one)
	if queue.size() > 4:
		var oldest = queue.pop_front()
		oldest.visible = false

