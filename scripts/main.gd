extends Node2D


var spins_left = 1
var spin_rotation_speed = 0.0
var spin_slow_down_time = 5.0
var wheel_spinning = false


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_to_main()
	if Global.enabled_music:
		$open_fields.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Wheel
	if wheel_spinning:
		# Gradually slow down the spinner over time
		if spin_slow_down_time > 0:
			# Gradually slow down the spinner over time
			spin_slow_down_time -= delta
			# Apply slowdown, significantly slowing down in the last second
			if spin_slow_down_time <= 1.0:
				spin_rotation_speed -= 2.5 * delta
			else:
				spin_rotation_speed -= 0.75 * delta
			# Stop spinning if time has elapsed or the rotation speed slows to a halt
			if spin_slow_down_time <= 0.0 or spin_rotation_speed <= 0.0:
				spin_wheel_stop()
			# Rotate the spinner
			$wheel/spinner/wheel_full.rotation += spin_rotation_speed * delta


# Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event):
	if event is InputEventAction and event.pressed:
		if event.action == "Ads":
			pass
		elif event.action == "Boosters":
			$boosters.visible = true
			$main.visible = false
			$menu.visible = false
			$top_close.visible = true
			$top_settings.visible = false
		elif event.action == "Character":
			open_character_selection()
		elif event.action == "Character1":
			Global.character = 1
			$character/name_label.text = "Foxy!"
			clear_character_selection()
			$character/won1.visible = true
			$character/character1/checkmark.visible = true
		elif event.action == "Character2":
			Global.character = 2
			$character/name_label.text = "George"
			clear_character_selection()
			$character/won2.visible = true
			$character/character2/checkmark.visible = true
		elif event.action == "Character3":
			Global.character = 3
			$character/name_label.text = "Kow!"
			clear_character_selection()
			$character/won3.visible = true
			$character/character3/checkmark.visible = true
		elif event.action == "Character4":
			Global.character = 4
			$character/name_label.text = "Bob!"
			clear_character_selection()
			$character/won4.visible = true
			$character/character4/checkmark.visible = true
		elif event.action == "Character5":
			Global.character = 5
			$character/name_label.text = "Rickon"
			clear_character_selection()
			$character/won5.visible = true
			$character/character5/checkmark.visible = true
		elif event.action == "Character6":
			Global.character = 6
			$character/name_label.text = "Beav!"
			clear_character_selection()
			$character/won6.visible = true
			$character/character6/checkmark.visible = true
		elif event.action == "Close":
			reset_to_main()
		elif event.action == "Coins":
			open_shop()
		elif event.action == "Friends":
			pass
		elif event.action == "Map":
			get_tree().change_scene_to_file("res://scenes/map.tscn")
		elif event.action == "Play":
			get_tree().change_scene_to_file("res://scenes/play.tscn")
		elif event.action == "Scores":
			$main.visible = false
			$menu.visible = false
			$scores.visible = true
			$top_close.visible = true
			$top_settings.visible = false
		elif event.action == "Settings":
			$main.visible = false
			$settings.visible = true
			$top_close.visible = true
			$top_settings.visible = false
		elif event.action == "Shop":
			open_shop()
		elif event.action == "Spin":
			spin_wheel_start()
		elif event.action == "ToggleMusic":
			Global.enabled_music = not Global.enabled_music
			$settings/music_off.visible = not Global.enabled_music
			$settings/music_on.visible = Global.enabled_music
			if Global.enabled_music:
				$open_fields.set_volume_db(0)
			else:
				$open_fields.set_volume_db(-100)
		elif event.action == "ToggleSound":
			Global.enabled_sound = not Global.enabled_sound
			$settings/sound_off.visible = not Global.enabled_sound
			$settings/sound_on.visible = Global.enabled_sound
		elif event.action == "Wheel":
			$main.visible = false
			$menu.visible = false
			$top_close.visible = true
			$top_settings.visible = false
			$wheel.visible = true


# Clears the characters on the Character Select screen.
func clear_character_selection():
	$character/won1.visible = false
	$character/character1/checkmark.visible = false
	$character/won2.visible = false
	$character/character2/checkmark.visible = false
	$character/won3.visible = false
	$character/character3/checkmark.visible = false
	$character/won4.visible = false
	$character/character4/checkmark.visible = false
	$character/won5.visible = false
	$character/character5/checkmark.visible = false
	$character/won6.visible = false
	$character/character6/checkmark.visible = false


func open_character_selection():
	$character.visible = true
	$main.visible = false
	$menu.visible = false
	$top_close.visible = true
	$top_settings.visible = false
	var node_path = "character/character" + str(Global.character) + "/checkmark"
	var node = get_node(node_path)
	node.visible = true


# Opens the scene's "shop" view.
func open_shop():
	$main.visible = false
	$menu.visible = false
	$shop.visible = true
	$top_close.visible = true
	$top_settings.visible = false


# Resets the scene's "main" view.
func reset_to_main():
	$boosters.visible = false
	$character.visible = false
	$main.visible = true
	$menu.visible = true
	$scores.visible = false
	$settings.visible = false
	$shop.visible = false
	$top_close.visible = false
	$top_settings.visible = true
	$wheel.visible = false


# Spins the wheel if able.
func spin_wheel_start():
	if spins_left > 0:
		spins_left -= 1
		$wheel/spins_label.text = str(spins_left)
		spin_rotation_speed = randf_range(5, 10)
		wheel_spinning = true


# Stops the wheel and awards the prize.
func spin_wheel_stop():
	wheel_spinning = false
	# Calculate the current angle of the spinner
	var spinner_rotation = $wheel/spinner/wheel_full.rotation_degrees
	var spinner_angle = int(spinner_rotation) % 360
	# Define the angles for each section (in degrees)
	var section_angles = [0, 45, 90, 135, 180, 225, 270, 315]
	# Determine the section based on the stopped angle
	var section_index = -1
	for i in range(section_angles.size()):
		if spinner_angle >= section_angles[i]:
			section_index = i
	# Print the section
	if section_index == 0:		# 0
		print("Coins")
	elif section_index == 1:	#45
		print("Bomb")
	elif section_index == 2:	#90
		print("Coins")
	elif section_index == 3:	#135
		print("Switch")
	elif section_index == 4:
		print("Coins")
	elif section_index == 5:
		print("Sugar")
	elif section_index == 6:
		print("Coins")
	elif section_index == 7:
		print("Milk")
