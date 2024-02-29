extends Node2D


# Constants for swipe direction
const SWIPE_UP = 1
const SWIPE_DOWN = -1
# Distance of scrolling (adjust as needed)
var scroll_distance = 1000
# Easing factor (adjust as needed, higher values mean faster easing)
var easing_factor = 5.0
# Variables to track touch positions
var initial_touch_position: Vector2
var target_scroll_position: float = 0


func _ready():
	if Global.enabled_sound: $all_that_glitters.play()
	# Initialize target_scroll_position to the initial position of the sprite
	target_scroll_position = $background.position.y
	# Levels
	if Global.player["level_1_complete"]:
		$background/levels/level1/blue.visible = true
	if Global.player["level_2_complete"]:
		$background/levels/level2/blue.visible = true
	if Global.player["level_3_complete"]:
		$background/levels/level3/blue.visible = true
	if Global.player["level_4_complete"]:
		$background/levels/level4/blue.visible = true
	# Highlight current level
	var node_path = "background/levels/level" + str(Global.current_level) + "/pink"
	var node = get_node(node_path)
	if node:
		node.visible = true


func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Level_1":
			open_level_goal(1)
		elif event.action == "Level_2":
			open_level_goal(2)
		elif event.action == "Level_3":
			open_level_goal(3)
		elif event.action == "Level_4":
			open_level_goal(4)
	elif event is InputEventScreenTouch:
		if event.is_pressed():
			# Store initial touch position
			initial_touch_position = event.position
		elif event.is_pressed() == false:
			# Calculate swipe direction based on initial and final touch positions
			var final_touch_position = event.position
			var swipe_vector = final_touch_position - initial_touch_position
			if abs(swipe_vector.y) > abs(swipe_vector.x):
				if swipe_vector.y > 0:
					#target_scroll_position = min($background.position.y + scroll_distance, $background.texture.get_size().y - $background.get_viewport_rect().size.y)
					target_scroll_position = min($background.position.y + scroll_distance, 0)
				else:
					target_scroll_position = max($background.position.y - scroll_distance, -5525)


func _process(delta):
	if abs($background.position.y - target_scroll_position) > 1.0:
		# Perform exponential easing towards the target position
		var distance_to_target = target_scroll_position - $background.position.y
		var easing_amount = distance_to_target * easing_factor * delta
		$background.position.y += easing_amount
	else:
		$background.position.y = target_scroll_position


func open_level_goal(level_id):
	var level_prior = level_id - 1
	level_prior = "level_" + str(level_prior) + "_complete"
	if Global.player[level_prior]:
		Global.current_level = level_id
		await get_tree().create_timer(0.2).timeout 
		get_tree().change_scene_to_file("res://scenes/goal.tscn")
