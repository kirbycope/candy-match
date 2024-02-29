extends TouchScreenButton


var swipe_start_position: Vector2 = Vector2.ZERO
var swipe_threshold: float = 10.0


func _ready():
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		# Track the start of the event (pressed)
		if event.pressed:
			swipe_start_position = event.position
		# Track the swipe direction
		else:
			var swipe_vector: Vector2 = event.position - swipe_start_position
			if swipe_vector.length() > swipe_threshold:
				if abs(swipe_vector.x) > abs(swipe_vector.y):
					if swipe_vector.x > 0:
						Global.swipe_direction = Vector2.RIGHT
					else:
						Global.swipe_direction = Vector2.LEFT
				else:
					if swipe_vector.y > 0:
						Global.swipe_direction = Vector2.DOWN
					else:
						Global.swipe_direction = Vector2.UP
