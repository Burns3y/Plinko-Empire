extends Node

var timer_wait_time: int = 60
@onready var timer = Timer.new()
func _ready():
	if GlobalVariables.income_per_minute >= 60:
		timer_wait_time = 5
	
	timer.wait_time = timer_wait_time
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.connect("timeout", self._on_income_tick)
	timer.start


func _on_income_tick():
	var dollars_per_tick: float
	if GlobalVariables.income_per_minute >= 60:
		timer_wait_time = 5
		dollars_per_tick = GlobalVariables.income_per_minute / (60/timer_wait_time)
		print("Dollars/tick ", dollars_per_tick)
	else:
		timer_wait_time = 60
		dollars_per_tick = GlobalVariables.income_per_minute
	GlobalVariables.coins += int(dollars_per_tick)
	GlobalVariables.coins = round(GlobalVariables.coins * 10) / 10.0
	
	# Updating cash display
	if get_tree().current_scene.name == "Plinko" or get_tree().current_scene.name == "Map":
		var coin_display = get_tree().current_scene.get_node("CoinDisplay")
		
		if coin_display:
			coin_display._update_label()
	
	timer.wait_time = timer_wait_time
