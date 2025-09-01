extends Node3D

@onready var TransitionCamera: Camera3D = $camreas/TransitionCamera
@onready var selected_camera: Camera3D = $camreas/Camera3D

var transitionTween: Tween
signal trans_complete

func _ready():
	# Connect signals
	$idle_buildings_buttons/button_100.connect("bought", self._on_100_bought)
	$idle_buildings_buttons/button_100._change_label(100, 2)
	$idle_buildings_buttons/button_500.connect("bought", self._on_500_bought)
	$idle_buildings_buttons/button_500._change_label(500, 10)
	$idle_buildings_buttons/button_1000.connect("bought", self._on_1k_bought)
	$idle_buildings_buttons/button_1000._change_label(1000, 25)
	$idle_buildings_buttons/button_5000.connect("bought", self._on_5k_bought)
	$idle_buildings_buttons/button_5000._change_label(5000, 150)
	$idle_buildings_buttons/button_10000.connect("bought", self._on_10k_bought)
	$idle_buildings_buttons/button_10000._change_label(10000, 400)
	$idle_buildings_buttons/button_50000.connect("bought", self._on_50k_bought)
	$idle_buildings_buttons/button_50000._change_label(50000, 2500)
	$idle_buildings_buttons/button_100000.connect("bought", self._on_100k_bought)
	$idle_buildings_buttons/button_100000._change_label(100000, 7000)
	$idle_buildings_buttons/button_500000.connect("bought", self._on_500k_bought)
	$idle_buildings_buttons/button_500000._change_label(500000, 45000)
	$idle_buildings_buttons/button_1000000.connect("bought", self._on_1M_bought)
	$idle_buildings_buttons/button_1000000._change_label(1000000, 120000)
	$idle_buildings_buttons/button_50000000.connect("bought", self._on_50M_bought)
	$idle_buildings_buttons/button_50000000._change_label(50000000, 900000)
	$idle_buildings_buttons/button_1000000000.connect("bought", self._on_1B_bought)
	$idle_buildings_buttons/button_1000000000._change_label(1000000000, 25000000)
	
	$Displays/CoinDisplay._update_label()
	$Displays/IncomeDisplay._update_label()
	_CameraIntro()


func _CameraIntro():
		selected_camera = $camreas/TransitionCamera
		if selected_camera == $camreas/TransitionCamera:
			await _change_camera($camreas/Camera3D2)
			
			if selected_camera == $camreas/Camera3D2:
				await _change_camera($camreas/StartCamera)
				
				if selected_camera == $camreas/StartCamera:
					await _change_camera($camreas/TouchscreenCamera)
					selected_camera = $camreas/TouchscreenCamera
					selected_camera.current = true


func _change_camera(desired_camera: Camera3D):
	
	if transitionTween:
		transitionTween.kill()

	transitionTween = get_tree().create_tween()
	var target_transform: Transform3D = desired_camera.global_transform
	transitionTween.tween_property(TransitionCamera, "transform", target_transform, 1.5).set_trans(Tween.TRANS_SINE)

	TransitionCamera.current = true
	selected_camera = desired_camera
	
	await transitionTween.finished
	emit_signal("trans_complete")


func _on_start_button_pressed():
	$Displays/StartButton.disabled = true
	$Displays/MenuButton.disabled = true
	await _change_camera($camreas/StartCamera)

	var tween := create_tween()
	tween.tween_property($ColorRect, "color", Color(0, 0, 0, 1), 0.5)
	await tween.finished
	
	$Displays/StartButton.disabled = false
	$Displays/MenuButton.disabled = false
	get_tree().change_scene_to_file("res://Scenes/Plinko/plinko.tscn")


func _on_menu_button_pressed():
	$Displays/StartButton.disabled = true
	$Displays/MenuButton.disabled = true
	var tween := create_tween()
	tween.tween_property($ColorRect, "color", Color(0, 0, 0, 1), 0.5)
	await tween.finished

	$Displays/StartButton.disabled = false
	$Displays/MenuButton.disabled = false
	get_tree().change_scene_to_file("res://menu.tscn")


# Functions with idle income values passed in
func _on_100_bought():
	_add_idle_income(2)

func _on_500_bought():
	_add_idle_income(10)

func _on_1k_bought():
	_add_idle_income(25)

func _on_5k_bought():
	_add_idle_income(150)

func _on_10k_bought():
	_add_idle_income(400)

func _on_50k_bought():
	_add_idle_income(2500)

func _on_100k_bought():
	_add_idle_income(7000)

func _on_500k_bought():
	_add_idle_income(45000)

func _on_1M_bought():
	_add_idle_income(120000)

func _on_50M_bought():
	_add_idle_income(900000)

func _on_1B_bought():
	_add_idle_income(25000000)

func _add_idle_income(value):
	$Displays/CoinDisplay._update_label()
	$Displays/IncomeDisplay._update_label()
	UsefulFunctions.save()
