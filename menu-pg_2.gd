extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_restart_pressed():
	print("Pressed")
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
