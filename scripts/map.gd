extends Node2D

# Constants for swipe direction
const SWIPE_UP = 1
const SWIPE_DOWN = -1

# Speed of scrolling (adjust as needed)
var scroll_speed = 1000

# Distance of scrolling (adjust as needed)
var scroll_distance = 500

# Easing factor (adjust as needed, higher values mean faster easing)
var easing_factor = 6.0

# Variables to track touch positions
var initial_touch_position: Vector2
var target_scroll_position: float = 0

func _ready():
	if Global.enabled_music:
		$all_that_glitters.play()
	# Initialize target_scroll_position to the initial position of the sprite
	target_scroll_position = $background.position.y

func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Coins":
			pass
		if event.action == "Close":
			if not Global.shoppette_hide():
				get_tree().change_scene_to_file("res://scenes/main.tscn")
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# Store initial touch position
			initial_touch_position = event.position
		elif event.is_pressed() == false:
			# Calculate swipe direction based on initial and final touch positions
			var final_touch_position = event.position
			var swipe_vector = final_touch_position - initial_touch_position
			if abs(swipe_vector.y) > abs(swipe_vector.x):
				if swipe_vector.y > 0:
					target_scroll_position = min($background.position.y + scroll_distance, $background.texture.get_size().y - $background.get_viewport_rect().size.y)
				else:
					target_scroll_position = max($background.position.y - scroll_distance, -1850)


func _process(delta):
	if abs($background.position.y - target_scroll_position) > 1.0:
		# Perform exponential easing towards the target position
		var distance_to_target = target_scroll_position - $background.position.y
		var easing_amount = distance_to_target * easing_factor * delta
		$background.position.y += easing_amount
	else:
		$background.position.y = target_scroll_position
