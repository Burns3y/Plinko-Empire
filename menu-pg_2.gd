extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu/Displays/CoinDisplay._update_label()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_restart_pressed():
	$Menu/MarginContainer/VBoxContainer/Restart.visible = false
	$Menu/MarginContainer/VBoxContainer/ConfirmRestartLabel.visible = true
	$Menu/MarginContainer/VBoxContainer/ConfirmRestartButtons.visible = true


func _on_confirm_restart_pressed():
	UsefulFunctions.reset()
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_cancel_restart_pressed():
	$Menu/MarginContainer/VBoxContainer/Restart.visible = true
	$Menu/MarginContainer/VBoxContainer/ConfirmRestartLabel.visible = false
	$Menu/MarginContainer/VBoxContainer/ConfirmRestartButtons.visible = false


func _on_mute_music_pressed():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")))
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")):
		$Menu/MarginContainer/VBoxContainer/MuteMusic.text = "Unmute Music"
	else:
		$Menu/MarginContainer/VBoxContainer/MuteMusic.text = "Mute Music"
	


func _on_mute_sfx_pressed():
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Music"), !AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")))
	if AudioServer.is_bus_mute(AudioServer.get_bus_index("Music")):
		$Menu/MarginContainer/VBoxContainer/MuteMusic.text = "Unmute Music"
	else:
		$Menu/MarginContainer/VBoxContainer/MuteMusic.text = "Mute Music"
