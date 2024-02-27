extends Node2D


var countdown_seconds = 30
var purchase_coins = 0
var purchase_cost = 0
var spin_rotation_speed = 0.0
var spin_slow_down_time = 2.0
var timer_running = false
var time_passed = 0.0
var update_interval = 1.0
var wheel_spinning = false


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_to_main()
	if Global.enabled_music:
		$open_fields.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Ad Timer
	if timer_running:
		if $shop/shoppette/video_overlay.visible:
			time_passed += delta
			if time_passed >= update_interval:
				update_countdown()
				time_passed = 0.0
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
			$top/close.visible = true
			$top_settings.visible = false
		elif event.action == "Boost_Purchase_Bundle_1":
			if Global.player["coins"] >= 350:
				Global.player["coins"] -= 350
				Global.player["bombs"] += 5
				Global.player["milks"] += 5
				Global.player["sugars"] += 5
				Global.player["switches"] += 5
		elif event.action == "Boost_Purchase_Bundle_2":
			if Global.player["coins"] >= 500:
				Global.player["coins"] -= 500
				Global.player["bombs"] += 5
				Global.player["milks"] += 5
				Global.player["sugars"] += 5
				Global.player["switches"] += 5
		elif event.action == "Boost_Purchase_5_Bombs":
			if Global.player["coins"] >= 200:
				Global.player["coins"] -= 200
				Global.player["bombs"] += 5
		elif event.action == "Boost_Purchase_5_Milks":
			if Global.player["coins"] >= 250:
				Global.player["coins"] -= 250
				Global.player["milks"] += 5
		elif event.action == "Boost_Purchase_5_Sugars":
			if Global.player["coins"] >= 150:
				Global.player["coins"] -= 150
				Global.player["sugars"] += 5
		elif event.action == "Boost_Purchase_5_Switches":
			if Global.player["coins"] >= 200:
				Global.player["coins"] -= 200
				Global.player["switches"] += 5
		elif event.action == "Character":
			open_character_selection()
		elif event.action == "Character1":
			Global.player["character"] = 1
			$character/name_label.text = "Foxy!"
			clear_character_selection()
			$character/character1/avatar.visible = true
			$character/character1/checkmark.visible = true
		elif event.action == "Character2":
			Global.player["character"] = 2
			$character/name_label.text = "George"
			clear_character_selection()
			$character/character2/avatar.visible = true
			$character/character2/checkmark.visible = true
		elif event.action == "Character3":
			Global.player["character"] = 3
			$character/name_label.text = "Kow!"
			clear_character_selection()
			$character/character3/avatar.visible = true
			$character/character3/checkmark.visible = true
		elif event.action == "Character4":
			Global.player["character"] = 4
			$character/name_label.text = "Bob!"
			clear_character_selection()
			$character/character4/avatar.visible = true
			$character/character4/checkmark.visible = true
		elif event.action == "Character5":
			Global.player["character"] = 5
			$character/name_label.text = "Rickon"
			clear_character_selection()
			$character/character5/avatar.visible = true
			$character/character5/checkmark.visible = true
		elif event.action == "Character6":
			Global.player["character"] = 6
			$character/name_label.text = "Beav!"
			clear_character_selection()
			$character/character6/avatar.visible = true
			$character/character6/checkmark.visible = true
		elif event.action == "Close":
			reset_to_main()
		elif event.action == "Friends":
			pass
		elif event.action == "Map":
			get_tree().change_scene_to_file("res://scenes/map.tscn")
		elif event.action == "Play":
			get_tree().change_scene_to_file("res://scenes/goal.tscn")
		elif event.action == "Reward_Back":
			spin_wheel_rewards_hide()
		elif event.action == "Scores":
			$main.visible = false
			$menu.visible = false
			$scores.visible = true
			$top/close.visible = true
			$top_settings.visible = false
		elif event.action == "Settings":
			$main.visible = false
			$settings.visible = true
			$top/close.visible = true
			$top_settings.visible = false
		elif event.action == "Shop":
			open_shop()
		elif event.action == "Shop_Ad_Close":
			ad_close()
		elif event.action == "Shop_Ad_Open":
			ad_open()
		elif event.action == "Shop_Ad_Play":
			ad_play()
		elif event.action == "Shop_Purchase_99":
			prepare_offer(250, 0.99)
		elif event.action == "Shop_Purchase_149":
			prepare_offer(500, 1.49)
		elif event.action == "Shop_Purchase_199":
			prepare_offer(700, 1.99)
		elif event.action == "Shop_Purchase_249":
			prepare_offer(1000, 2.49)
		elif event.action == "Shop_Purchase_299":
			prepare_offer(1500, 2.99)
		elif event.action == "Shop_Purchase_Cancel":
			retract_offer()
		elif event.action == "Shop_Purchase_Confirm":
			purchase_confirm()
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
			$top/close.visible = true
			$top_settings.visible = false
			$wheel.visible = true
			$wheel/spins_left/Label.text = str(Global.player["spins_remaining"])


func ad_close():
	$shop/shoppette/video_overlay.visible = false


func ad_open():
	OS.shell_open("https://timothycope.com/")


func ad_play():
	$shop/shoppette/video_overlay.visible = true
	countdown_seconds = 30
	timer_running = true
	$shop/shoppette/video_overlay/CenterContainer/VideoStreamPlayer.play()
	$shop/shoppette/video_overlay/CenterContainer/VideoStreamPlayer.loop = true # DEBUGGING clip is short
	$shop/shoppette/video_overlay/Label.text = "reward in " + str(countdown_seconds) + "..."


# Clears the characters on the Character Select screen.
func clear_character_selection():
	$character/character1/avatar.visible = false
	$character/character1/checkmark.visible = false
	$character/character2/avatar.visible = false
	$character/character2/checkmark.visible = false
	$character/character3/avatar.visible = false
	$character/character3/checkmark.visible = false
	$character/character4/avatar.visible = false
	$character/character4/checkmark.visible = false
	$character/character5/avatar.visible = false
	$character/character5/checkmark.visible = false
	$character/character6/avatar.visible = false
	$character/character6/checkmark.visible = false


func open_character_selection():
	reset_to_main()
	$character.visible = true
	$main.visible = false
	$menu.visible = false
	$top/close.visible = true
	$top_settings.visible = false
	var node_path = "character/character" + str(Global.player["character"]) + "/checkmark"
	var node = get_node(node_path)
	node.visible = true


# Opens the scene's "shop" view.
func open_shop():
	reset_to_main()
	$main.visible = false
	$menu.visible = false
	$shop.visible = true
	$top/close.visible = true
	$top_settings.visible = false


func prepare_offer(coins, cost):
	if $shop/shoppette/purchase_overlay.visible == false:
		purchase_coins = coins
		purchase_cost = cost
		$shop/shoppette/purchase_overlay.visible = true
		$shop/shoppette/purchase_overlay/CenterContainer/item_texture.texture = load("res://assets/shop coins3.png")
		$shop/shoppette/purchase_overlay/CenterContainer/coins.text = str(purchase_coins) + " coins"
		$shop/shoppette/purchase_overlay/CenterContainer/confirm.text = "$" + str(purchase_cost)


func purchase_confirm():
	Global.player["coins"] += purchase_coins
	retract_offer()


# Resets the scene's "main" view.
func reset_to_main():
	$top.shoppette_hide()
	if Global.player["level_0_complete"] == false:
		$main/play_button.texture = load("res://assets/main play button.png")
	else:
		$main/play_button.texture = load("res://assets/button play.png")
	$boosters.visible = false
	$character.visible = false
	$main.visible = true
	$menu.visible = true
	$scores.visible = false
	$settings.visible = false
	$shop.visible = false
	$top/close.visible = false
	$top_settings.visible = true
	$wheel.visible = false
	$wheel/reward.visible = false
	$wheel/spinner.visible = true


func retract_offer():
	$shop/shoppette/purchase_overlay.visible = false
	purchase_coins = 0
	purchase_cost = 0.00


func spin_wheel_rewards_hide():
	$wheel/reward.visible = false
	$wheel/spinner.visible = true


func spin_wheel_rewards_show(prize):
	$wheel/reward.visible = true
	$wheel/spinner.visible = false
	var texture_path = "res://assets/wheel prize" + str(prize) + ".png"
	$wheel/reward/item.texture = load(texture_path)
	if prize == 1:
		$wheel/reward/Label.text = "5 bombs"
		Global.player["bombs"] += 5
	elif prize == 2:
		$wheel/reward/Label.text = "20 Coins"
		Global.player["coins"] += 20
	elif prize == 3:
		$wheel/reward/Label.text = "5 milks"
		Global.player["milks"] += 5
	elif prize == 4:
		$wheel/reward/Label.text = "5 switches"
		Global.player["switches"] += 5
	elif prize == 5:
		$wheel/reward/Label.text = "5 sugars"
		Global.player["sugars"] += 5


# Spins the wheel if able.
func spin_wheel_start():
	if Global.player["spins_remaining"] > 0:
		Global.player["spins_remaining"] -= 1
		$wheel/spins_left/Label.text = str(Global.player["spins_remaining"])
		spin_slow_down_time = 2.0
		spin_rotation_speed = randf_range(5, 10)
		wheel_spinning = true
		#$playful_casino_slot_machine_jackpot_1.play()
	else:
		$wheel/come_back.visible = not $wheel/come_back.visible


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
		if spinner_angle + 30 >= section_angles[i]:
			section_index = i
	var prize = 0
	if section_index == 0:
		prize = 2 # "Coins"
	elif section_index == 1:
		prize = 1 # "Bomb")
	elif section_index == 2:
		prize = 2 # "Coins"
	elif section_index == 3:
		prize = 4 # ("Switch")
	elif section_index == 4:
		prize = 2 # "Coins"
	elif section_index == 5:
		prize = 5 # ("Sugar")
	elif section_index == 6:
		prize = 2 # "Coins"
	elif section_index == 7:
		prize = 3 # ("Milk")
	await get_tree().create_timer(0.5).timeout
	spin_wheel_rewards_show(prize)


func update_countdown():
	if countdown_seconds > 0:
		countdown_seconds -= 1
		$shop/shoppette/video_overlay/Label.text = "reward in " + str(countdown_seconds) + "..."
	else:
		timer_running = false
		$shop/shoppette/video_overlay/Label.text = "received 250 coins"
		Global.player["coins"] += 250
