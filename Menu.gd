extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_btn_pressed():
	get_tree().change_scene_to_file("res://Scenes/map.tscn")


func _on_options_btn_pressed():
	get_tree().change_scene_to_file("res://menu-pg_2.tscn")


func _on_quit_btn_pressed():
	get_tree().quit()
