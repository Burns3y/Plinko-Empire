extends Area3D

signal bought

func _input_event(_camera, event, _pos, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if InputMap.action_has_event("left_click", event):
			if $"..".cost <= GlobalVariables.coins:
				hide()
				$".."/second_build.visible = true
				GlobalVariables.coins -= $"..".cost
				GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
				
				bought.emit()
			else: print("brokie")
