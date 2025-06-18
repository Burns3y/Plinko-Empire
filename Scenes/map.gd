extends Node3D

@onready var TransitionCamera: Camera3D = $camreas/TransitionCamera
@onready var selected_camera: Camera3D = $camreas/Camera3D

var transitionTween: Tween

func _ready():
	$StartButton.connect("started", self.start_plinko)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if selected_camera == $camreas/Camera3D2:
			_change_camera($camreas/StartCamera)
		else:
			_change_camera($camreas/Camera3D2)
	if Input.is_action_just_pressed("ui_down"):
		start_plinko()


func _change_camera(desired_camera: Camera3D):
	if transitionTween:
		transitionTween.kill()

	transitionTween = get_tree().create_tween()
	var target_transform: Transform3D = desired_camera.global_transform
	transitionTween.tween_property(TransitionCamera, "transform", target_transform, 1.5).set_trans(Tween.TRANS_SINE)

	TransitionCamera.current = true
	selected_camera = desired_camera


func start_plinko():
	get_tree().change_scene_to_file("res://Scenes/Plinko/plinko.tscn")



func _on_button_pressed():
	start_plinko()
