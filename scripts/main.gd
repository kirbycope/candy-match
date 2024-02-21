extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	preload("res://assets/punchy-taps-ui-1-183897.mp3")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _input(event):
	# Check if the event is an InputEventAction and matches our action
	if event is InputEventAction and event.pressed:
		$taps_1.play()
		#await $taps_1.finished # this causes a delay for almost no reason
		if event.action == "Ads":
			get_tree().change_scene_to_file("res://scenes/boosters.tscn")
		elif event.action == "Boosters":
			get_tree().change_scene_to_file("res://scenes/boosters.tscn")
		elif event.action == "Character":
			get_tree().change_scene_to_file("res://scenes/character.tscn")
		elif event.action == "Close":
			$main.visible = true
			$top_close.visible = false
			$top_settings.visible = true
		elif event.action == "Coins":
			get_tree().change_scene_to_file("res://scenes/coins.tscn")
		elif event.action == "Friends":
			get_tree().change_scene_to_file("res://scenes/friends.tscn")
		elif event.action == "Map":
			get_tree().change_scene_to_file("res://scenes/map.tscn")
		elif event.action == "Play":
			pass
		elif event.action == "Scores":
			get_tree().change_scene_to_file("res://scenes/scores.tscn")
		elif event.action == "Settings":
			$main.visible = false
			$top_close.visible = true
			$top_settings.visible = false
		elif event.action == "Shop":
			get_tree().change_scene_to_file("res://scenes/settings.tscn")
		elif event.action == "Wheel":
			get_tree().change_scene_to_file("res://scenes/wheel.tscn")
