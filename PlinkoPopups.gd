extends Control


func _show_popup(text, good_message: bool = true):
	$Label.text = text
	$Label.visible = true
	var label_scale = $Label.scale
	
	# Setting up tweens and basic colours
	var tween = get_tree().create_tween()
	$Label.modulate = Color.WHITE
	
	if good_message:
		# Green text
		$Label.modulate = Color(0, 1, 0)  
		# Scale up then back down (like a pop)
		if GlobalVariables.animations_on:
			tween.tween_property($Label, "scale", label_scale * 1.3, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
			tween.tween_property($Label, "scale", label_scale, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	else:
		# Red text
		$Label.modulate = Color(1, 0, 0)
		# Shake left-right quickly
		if GlobalVariables.animations_on:
			for i in range(3):
				tween.tween_property($Label, "position:x", $Label.position.x - 15, 0.1)
				tween.tween_property($Label, "position:x", $Label.position.x + 15, 0.1)
			tween.tween_property($Label, "position:x", $Label.position.x, 0.05)
		
	# Fades out and deletes itself
	tween.tween_property($Label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(self.queue_free)
