extends RigidBody2D

var value: int = 1

func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if global_position.y > 1280:
		queue_free()

func _on_timer_timeout():
	if global_position.x == 0:
		linear_velocity.x = 15
	else:
		linear_velocity.x = sign(global_position.x - 360) * 15

	if $Timer.wait_time >= 2:
		$Timer.wait_time -= 2
	$Timer.start()
