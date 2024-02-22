extends Node2D


var character = 1
var enabled_music = true
var enabled_sound = true
var spins_left = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	reset_to_main()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.


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
			$character.visible = true
			$main.visible = false
			$menu.visible = false
			$top_close.visible = true
			$top_settings.visible = false
		elif event.action == "Character1":
			character = 1
			$character/name_label.text = "Foxy!"
			clear_character_selection()
			$character/won1.visible = true
			$character/character1/checkmark.visible = true
		elif event.action == "Character2":
			character = 2
			$character/name_label.text = "George"
			clear_character_selection()
			$character/won6.visible = true
			$character/character2/checkmark.visible = true
		elif event.action == "Character3":
			character = 3
			$character/name_label.text = "Kow!"
			clear_character_selection()
			$character/won5.visible = true
			$character/character3/checkmark.visible = true
		elif event.action == "Character4":
			character = 4
			$character/name_label.text = "Bob!"
			clear_character_selection()
			$character/won2.visible = true
			$character/character4/checkmark.visible = true
		elif event.action == "Character5":
			character = 5
			$character/name_label.text = "Rickon"
			clear_character_selection()
			$character/won4.visible = true
			$character/character5/checkmark.visible = true
		elif event.action == "Character6":
			character = 6
			$character/name_label.text = "Beav!"
			clear_character_selection()
			$character/won3.visible = true
			$character/character6/checkmark.visible = true
		elif event.action == "Close":
			reset_to_main()
		elif event.action == "Coins":
			open_shop()
		elif event.action == "Friends":
			pass
		elif event.action == "Map":
			pass
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
			if spins_left > 0:
				print("You have " + str(spins_left) + " spins left.")
				spins_left -= 1
				$wheel/spins_label.text = str(spins_left)
			else:
				print("Come back later.")
		elif event.action == "ToggleMusic":
			enabled_music = not enabled_music
			$settings/music_off.visible = not enabled_music
			$settings/music_on.visible = enabled_music
			if enabled_music:
				$open_fields.set_volume_db(0)
			else:
				$open_fields.set_volume_db(-100)
		elif event.action == "ToggleSound":
			enabled_sound = not enabled_sound
			$settings/sound_off.visible = not enabled_sound
			$settings/sound_on.visible = enabled_sound
		elif event.action == "Wheel":
			$main.visible = false
			$menu.visible = false
			$top_close.visible = true
			$top_settings.visible = false
			$wheel.visible = true
		if enabled_sound:
			$taps_1.play()


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
