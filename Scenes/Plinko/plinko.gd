extends Node2D

#Preloading balls
var ball: PackedScene = preload("res://Scenes/Plinko/plinko_ball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	#for pin in $Pins.get_children():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ball_drop_pressed():
	var new_ball = ball.instantiate()
	var new_ball_pos = randf_range(-10, 10)
	new_ball.name = "Ball"
	$Balls.add_child(new_ball)
	new_ball.position = $BallSpawnPoint.position + Vector2(new_ball_pos, 0)
