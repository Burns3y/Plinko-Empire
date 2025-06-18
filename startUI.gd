extends Node3D

signal started



func _on_button_pressed():
	started.emit()
	print("Button")
